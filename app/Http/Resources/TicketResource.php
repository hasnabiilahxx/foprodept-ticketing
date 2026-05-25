<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TicketResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     * @return array<string, mixed>
     */
    public function toArray ($request)
    {
        return [
            'id' => $this->id,
            'user' => new UserResource($this->user),
            'code' => $this->code,
            'title' => $this->title,
            'description' => $this->description,
            'status' => $this->status,
            'category' => $this->category,
            'priority' => $this->priority,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'completed_at' => $this->completed_at,
            'attachment' => $this->attachment 
                ? asset('storage/' . $this->attachment)
                : null,
            'ticket_replies' => TicketReplyResource::collection($this->ticketReplies)
        ];
    }
}
