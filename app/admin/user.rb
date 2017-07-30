ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :username
    column :created_at
    actions
  end

  filter :username
  filter :created_at

  form do |f|
    f.inputs do
      f.input :username
      f.input :password
      f.input :password_confirmation
      f.input :biography
    end
    f.actions
  end

end
