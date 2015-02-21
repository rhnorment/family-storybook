ActiveAdmin.register User do

  menu    priority: 2

  permit_params :name, :email

  index do
    selectable_column
    column  :name
    column  :email
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs  :name, :email
    actions
  end


end
