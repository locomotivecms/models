# module Locomotive
#   module Entities
#     class Dummy
#       include Entity
#       attributes :name
#     end
#   end
# end
#
# @mapper = Locomotive::Mapper.new do
#   collection :dummy do
#     entity Locomotive::Entities::Dummy
#     attribute :name, localized: true
#   end
# end
#
# @datastore = Locomotive::Datastore.new
# @adapter   = Locomotive::Adapters::MemoryAdapter.new @mapper
#
# class Locomotive::DummyRepository
#   include Locomotive::Repository
# end
#
# @repository = Locomotive::DummyRepository.new(@datastore, @adapter)
