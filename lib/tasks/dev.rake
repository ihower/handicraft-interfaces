namespace :dev do
    
  desc "Build for development and test"
  task :build => ["db:drop","db:create","db:migrate",:setup]
  
  desc "Setup default data"
  task :setup => :environment do
      i = Item.create!( :name => 'foobar 1', :description => 'blah 1', :position => 1 )
      Item.create!( :name => 'foobar 2', :description => 'blah 2', :position => 2 )
      Item.create!( :name => 'foobar 3', :description => 'blah 3', :position => 4 )
      Item.create!( :name => 'foobar 4', :description => 'blah 4', :position => 3 )
      
      Option.create!( :name => 'option 1', :item => i )
      Option.create!( :name => 'option 2', :item => i )
      Option.create!( :name => 'option 3', :item => i )
      
      Category.create!( :name => 'Category 1')
      Category.create!( :name => 'Category 2')
      Category.create!( :name => 'Category 3')
      
  end
end