records = [{ title: 'new article', content: 'nothing has changed' }]

records.each do |record|
  @repository.create(Locomotive::Entities::Article.new(record), :en)
end
