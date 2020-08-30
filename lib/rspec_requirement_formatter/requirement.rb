require "json"

module RspecRequirementFormatter
  class Requirement
    attr_accessor :example_groups

    def initialize
      @example_groups = []
    end

    def add(example_group)
      @example_groups << example_group
    end

    def to_json
      @example_groups.map { |example_group| group_hash(example_group) }.to_json
    end

    private

    def group_hash(example_group)
      {
        type: "example_group",
        description: example_group.description,
        examples: example_group.examples.map { |example| example_hash(example) },
        children: example_group.children.map { |example_group| group_hash(example_group) }
      }
    end

    def example_hash(example)
      {
        type: "example",
        description: example.description
      }
    end
  end
end
