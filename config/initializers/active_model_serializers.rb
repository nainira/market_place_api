ActiveSupport.on_load(:active_model_serializers) do
  # Disable for all serializers (except ArraySerializer)
  ActiveModel::Serializer.root = false
  # ActiveModel::Serializer.embed = :ids
  # config.embed_in_root = false

  # Disable for ArraySerializer
  # ActiveModel::ArraySerializer.root = false
end