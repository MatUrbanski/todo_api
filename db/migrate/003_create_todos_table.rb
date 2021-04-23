# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:todos) do
      column :id,          :uuid, null: false, default: Sequel.function(:uuid_generate_v4), primary_key: true
      column :name,        String, null: false
      column :description, String, null: false
      column :created_at,  DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at,  DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP

      foreign_key :user_id, :users, type: 'uuid', null: false, on_delete: :cascade
    end
  end
end
