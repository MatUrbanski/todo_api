# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:users) do
      column :id,                   :uuid,    null: false, default: Sequel.function(:uuid_generate_v4), primary_key: true
      column :email,                'citext', null: false, unique: true
      column :password_digest,      String,   null: false
      column :authentication_token, String,   null: false, unique: true
      column :created_at,           DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at,           DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
