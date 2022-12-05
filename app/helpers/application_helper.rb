module ApplicationHelper
  include Pagy::Frontend

  def default_meta_tags
    {
      title: 'Fuji X Recipes',
      reverse: true,
      separator: '·',
      description: 'Fujifilm camera recipes browser',
    }
  end
end
