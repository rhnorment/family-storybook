ActiveAdmin.register Storybook do

    config.sort_order = 'title_asc'

    menu            priority: 3

    permit_params   :title

    index do
      selectable_column
      column  :title
      column  'Author' do |storybook|
        storybook.user.name
      end
      column  'Stories' do |storybook|
        storybook.stories.count
      end
      column  'Published?' do |storybook|
        storybook.published?
      end
      actions
    end

end


