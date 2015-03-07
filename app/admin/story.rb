ActiveAdmin.register Story do

  config.sort_order = 'title_asc'

  menu            priority: 4

  permit_params   :title

  index do
    selectable_column
    column  :title
    column  'Author' do |story|
      story.user.name
    end
    actions
  end


end
