module SystemName

  extend ActiveSupport::Concern

  included do
    before_validation :generate_system_name, on: :create
    class_attribute :_system_human_name

    field :name, type: String
    field :system_name, type: String
  end

  module ClassMethods

    def validates_system_name(opts = {})
      validates :system_name, presence: true, format: { with: /\A\w[\w\-\/_]+\z/ }
      validates :name, presence: true

      if opts[:uniqueness_scope]
        validates :system_name, uniqueness: opts[:uniqueness_scope] == true ? true : { scope: opts[:uniqueness_scope] }
      end
    end

    def has_system_name(opts = {})
      attr_protected :system_name if opts.delete(:protected)
      self._system_human_name = opts.delete(:human_name) || :name
      validates_system_name(opts)
    end
  end

  protected

    def system_human_name
      send(self._system_human_name)
    end

    # Generates system_name from 'system_human_name'
    def generate_system_name
      generate_system_name! if self.system_name.blank?
    end

    def generate_system_name!
      if self.system_human_name.present?
        slug = self.system_human_name.parameterize.underscore
        self.system_name = slug.blank? ? internal_system_name : slug
      end
    end

    # This method is used when we need to generate a system_name
    # but ther is no suitable 'name' (human_name) from which
    # we can guess a reasonable one.
    #
    def internal_system_name
      "#{self.class.to_s}_#{SecureRandom.hex(6)}"
    end
end
