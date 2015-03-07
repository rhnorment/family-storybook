ActiveAdmin.register User do

  config.sort_order = 'name_asc'

  menu    priority: 2

  permit_params :name, :email

  index do
    selectable_column
    column  :name
    column  :email
    column  'Storybooks' do |user|
      user.storybooks.count
    end
    column  'Stories' do |user|
      user.stories.count
    end
    column  'Family Members' do |user|
      user.relatives.count
    end
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs  :name, :email
    actions
  end


end
