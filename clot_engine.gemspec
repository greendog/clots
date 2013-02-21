require 'rake'

Gem::Specification.new do |s|
  s.name = 'clot_engine'
  s.summary = "Clot Engine"
  s.authors = ["Jim Gilliam, Alexander Negoda"]
  s.email = ["alexander.negoda@gmail.com"]
  s.description = "Extensions for solidifying Liquid Templates"
  s.homepage = "https://github.com/greendog/clots"
  s.version = "1.2.0"
  s.files = FileList["lib/**/*.rb"].to_a

  #s.add_dependency 'mongo_mapper', '>= 0.12.0'

end
