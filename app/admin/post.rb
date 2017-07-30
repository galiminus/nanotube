ActiveAdmin.register Post do
  permit_params :name, :content_type, :path, :md5, :size, :thumbnail, :owner, :title, :state, :description

  index do
    selectable_column
    id_column
    column :title
    column :created_at
    actions
  end

  filter :title
  filter :created_at

  form do |f|
    f.inputs do
      f.input :title
      f.input :name
      f.input :content_type
      f.input :description
      f.input :path
      f.input :md5
      f.input :size
      f.input :state
    end
    f.actions
  end

end
