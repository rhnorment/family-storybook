ActiveAdmin.register Storybook do

  menu            priority: 3

    permit_params   :title

    index do
      selectable_column
      column  :title
      column  'User' do |storybook|
        storybook.user.name
      end
      actions
    end

end


