ActiveAdmin.register Story do


  menu            priority: 4

  permit_params   :title

  index do
    selectable_column
    column  :title do |story|
      link_to story.title, story
    end
    column  'User' do |story|
      story.user.name
    end
    actions
  end


end
