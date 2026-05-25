<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Resources\UserResource;
use Illuminate\Support\Facades\Auth;
use App\Http\Requests\RegisterStoreRequest;
use Illuminate\Auth\Events\Registered;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;
use Exception;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        try {
            if(!Auth::guard('web')->attempt($request->only('email', 'password'))){
                return response()->json([
                    'message' => 'Unautohorized',
                    'data' => null
                ], 401);
            }

            $user = Auth::user();

            // [!] CEK: Apakah email sudah diverifikasi?
            if (!$user->hasVerifiedEmail()) {
                Auth::logout();
                return response()->json([
                    'message' => 'Email belum diverifikasi. Silakan cek inbox email Anda.',
                    'data' => null
                ], 403);
            }

            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                    'message' => 'Login Berhasil',
                    'data' => [
                        'token' => $token,
                        'user' => new UserResource($user)
                    ]
                ], 200);

        } catch (Exception $e) {
            return response()->json([
                    'message' => 'Terjadi Kesalahan',
                    'error' => $e->getMessage()
                ], 500);
        }
    }

    public function me()
    {
        try {
            $user = Auth::user();

            return response()->json([
                'message' => 'Profile User Berhasil diambil',
                'data' => new UserResource($user)
            ], 200);

        } catch (Exception $e) {
            return response()->json([
                'message' => 'Terjadi Kesalahan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function logout()
    {
        try {
            $user = Auth::user();
            $user->currentAccessToken()->delete();

            return response()->json([
                'message' => 'Logout Berhasil',
                'data' => null
            ], 200);

        } catch (Exception $e) {
            return response()->json([
                'message' => 'Terjadi Kesalahan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function register(RegisterStoreRequest $request) {
        $data = $request->validated();

        DB::beginTransaction();

        try {
            $user = new User;
            $user->name = $data['name'];
            $user->email = $data['email'];
            $user->password = Hash::make($data['password']);
            $user->save();

            // [!] TAMBAH BARIS INI — Kirim email verifikasi
            event(new \Illuminate\Auth\Events\Registered($user));

            DB::commit();

            return response()->json([
                'message' => 'Registrasi Berhasil! Silakan cek email untuk verifikasi.',
                'data' => null // [!] Jangan kasih token, tunggu email verified dulu
            ], 201);
        
        } catch (Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Terjadi Kesalahan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function changePassword(Request $request)
    {
        try {
            $user = Auth::user();

            // [!] Validasi
            $request->validate([
                'old_password' => 'required|min:6',
                'password' => 'required|min:6|confirmed',
            ]);

            // [!] Cek password lama
            if (!Hash::check($request->old_password, $user->password)) {
                return response()->json([
                    'message' => 'Password lama tidak sesuai',
                ], 422);
            }

            // [!] Update password baru
            $user->update([
                'password' => Hash::make($request->password)
            ]);

            return response()->json([
                'message' => 'Password berhasil diubah',
                'data' => null
            ], 200);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Validasi gagal',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // [!] Method verifikasi email
    public function verifyEmail(Request $request, $id, $hash)
    {
        try {
            $user = User::findOrFail($id);

            // Validasi hash
            if (!hash_equals(sha1($user->getEmailForVerification()), $hash)) {
                return response()->json([
                    'message' => 'Link verifikasi tidak valid'
                ], 400);
            }

            // Cek apakah sudah verified
            $frontendUrl = rtrim(env('FRONTEND_URL', config('app.url')), '/');

            if ($user->hasVerifiedEmail()) {
                return redirect($frontendUrl . '/auth/login?verified=already');
            }

            // [!] Mark email sebagai verified
            $user->markEmailAsVerified();

            // Trigger event Verified (optional)
            event(new \Illuminate\Auth\Events\Verified($user));

            // Redirect ke login dengan parameter verified=1
            return redirect($frontendUrl . '/auth/login?verified=1');

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // [!] Method kirim ulang email verifikasi
    public function resendVerification(Request $request)
    {
        try {
            $request->validate([
                'email' => 'required|email|exists:users,email'
            ]);

            $user = User::where('email', $request->email)->first();

            // Cek apakah sudah verified
            if ($user->hasVerifiedEmail()) {
                return response()->json([
                    'message' => 'Email sudah terverifikasi'
                ], 400);
            }

            // Kirim ulang email verifikasi
            $user->sendEmailVerificationNotification();

            return response()->json([
                'message' => 'Email verifikasi berhasil dikirim ulang. Cek inbox Anda.'
            ], 200);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Validasi gagal',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
