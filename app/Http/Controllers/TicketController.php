<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Requests\TicketStoreRequest;
use App\Http\Resources\TicketResource;
use App\Http\Resources\TicketReplyResource;
use App\Http\Requests\TicketReplyStoreRequest;
use App\Models\TicketReply;
use App\Models\Ticket;




class TicketController extends Controller
{
    public function index(Request $request)
    {
        try {
            $query = Ticket::query();

            // [!] SEARCH
            if ($request->search) {
                $query->where(function ($q) use ($request) {
                    $q->where('code', 'like', '%' . $request->search . '%')
                        ->orWhere('title', 'like', '%' . $request->search . '%');
                });
            }

            // [!] FILTER STATUS
            if ($request->status) {
                $query->where('status', $request->status);
            }

            // [!] FILTER CATEGORY
            if ($request->category_id) {
                $query->where('category_id', $request->category_id);
            }

            // [!] FILTER PRIORITY
            if ($request->priority) {
                $query->where('priority', $request->priority);
            }

            // [!] FILTER MONTH & YEAR
            if ($request->month || $request->year) {
                if ($request->month) {
                    $query->whereMonth('created_at', $request->month);
                }
                if ($request->year) {
                    $query->whereYear('created_at', $request->year);
                }
            } elseif ($request->date) {
                if ($request->date == 'today') {
                    $query->whereDate('created_at', today());
                }
                if ($request->date == 'week') {
                    $query->whereBetween('created_at', [
                        now()->startOfWeek(),
                        now()->endOfWeek()
                    ]);
                }
                if ($request->date == 'month') {
                    $query->whereMonth('created_at', now()->month);
                }
            }

            // [!] FILTER USER ROLE
            if (auth()->user()->role == 'user') {
                $query->where('user_id', auth()->user()->id);
            }

            // [!] TAMBAH INI — SORTING LOGIC
            $sortBy = $request->sort_by ?? 'created_at';
            $sortOrder = $request->sort_order ?? 'desc';

            // Whitelist columns yang boleh di-sort
            $allowedSortColumns = ['code', 'title', 'status', 'priority', 'created_at'];
            
            if (in_array($sortBy, $allowedSortColumns)) {
                $query->orderBy($sortBy, $sortOrder);
            } else {
                // Default sort kalau ada input yang invalid
                $query->orderBy('created_at', 'desc');
            }

            // [!] HANDLE LIMIT (untuk recent tickets)
            if ($request->limit) {
                $tickets = $query->limit($request->limit)->get();
                
                return response()->json([
                    'message' => 'Data Ticket Berhasil Ditampilkan',
                    'data' => TicketResource::collection($tickets),
                ], 200);
            }

            // [!] PAGINATION
            $perPage = $request->per_page ?? 10;
            $tickets = $query->paginate($perPage);

            return response()->json([
                'message' => 'Data Ticket Berhasil Ditampilkan',
                'data' => TicketResource::collection($tickets),
                'meta' => [
                    'current_page' => $tickets->currentPage(),
                    'last_page'    => $tickets->lastPage(),
                    'per_page'     => $tickets->perPage(),
                    'total'        => $tickets->total(),
                ]
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan',
                'data' => null
            ], 500);
        }
    }

    public function show($code) {
        try {
            $ticket = Ticket::where('code', $code)->first();

            if (!$ticket) {
                return response()->json([
                    'message' => 'Ticket tidak ditemukan'
                ], 404);
            }

            if (auth()->user()->role == 'user' && $ticket->user_id != auth()->user()->id) {
                return response()->json([
                    'message' => 'Anda Tidak Diperbolehkan Mengakses Ticket Ini'
                ], 403);
            }

            return response()->json([
                'message' => 'Ticket berhasil ditampilkan',
                'data' => new TicketResource($ticket)
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Terjadi Kesalahan',
                'data' => $e->getMessage()
            ], 500);
        }
    }

    public function store(TicketStoreRequest $request)
    {
        $data = $request->validated();

        DB::beginTransaction();

        try {
            $ticket = new Ticket();
            $ticket->user_id = auth()->user()->id;
            $ticket->code = 'TIC-DHH-' . rand(10000, 99999);
            $ticket->title = $data['title'];
            $ticket->description = $data['description'];
            $ticket->category_id = $data['category_id'];
            $ticket->priority = $data['priority'];

            // ✅ HANDLE FILE SEBELUM SAVE TERAKHIR
            if ($request->hasFile('attachment')) {
                $file = $request->file('attachment');
                $path = $file->store('attachments', 'public');

                $ticket->attachment = $path;
            }

            $ticket->save(); 

            DB::commit();

            return response()->json([
                'message' => 'Ticket berhasil ditambahkan',
                'data' => new TicketResource($ticket)
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'message' => $e->getMessage(), // 🔥 sementara biar keliatan error asli
            ], 500);
        }
    }
         
    public function storeReply(TicketReplyStoreRequest $request, $code)
    {
        $data = $request->validated();

        DB::beginTransaction();

        try {
            $ticket = Ticket::where('code', $code)->first();
            if (in_array($ticket->status, ['resolved', 'rejected'])) {
                return response()->json([
                    'message' => 'Tiket sudah ditutup, tidak bisa membalas'
                ], 403);
            }

            if (!$ticket) {
                return response()->json([
                    'message' => 'Tiket tidak ditemukan'
                ], 404);
            }

            if (auth()->user()->role == 'user' && $ticket->user_id != auth()->user()->id) {
                return response()->json([
                    'message' => 'Anda tidak diperbolehkan membalas tiket ini'
                ], 403);
            }

            $ticketReply = new TicketReply();
            $ticketReply->ticket_id = $ticket->id; 
            $ticketReply->user_id = auth()->user()->id; 
            $ticketReply->content = $data['content']; 
            $ticketReply->save();

            if (auth()->user()->role == 'admin') {
                $ticket->status = $data['status'];
                if ($data['status'] == 'resolved') {
                    $ticket->completed_at = now();
                }
                $ticket->save();
            }

            DB::commit();

            return response()->json([
                'message' => 'Balasan berhasil ditambahkan',
                'data' => new TicketReplyResource($ticketReply)
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'message' => 'Terjadi kesalahan',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
