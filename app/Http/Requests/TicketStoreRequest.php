<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class TicketStoreRequest extends FormRequest
{

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules()
    {
        return [
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'priority' => 'required|string|in:low,medium,high',
            'category_id' => 'required|exists:categories,id',
            'attachment' => 'nullable|file|mimes:jpg,jpeg,png,doc,docx,xls,xlsx|max:10240',
        ];
    }
}
