module KoalaClient
  module LintuvaaraUser

    def self.included(model)
      model.extend(ClassMethods)
      model.send(:include, InstanceMethods)
    end

    module ClassMethods

      # Wrapper; Sometimes it should be explicitly stated that we are searching by ringer_id.
      #
      # ActiveResourcessa on bugi, tulee mystinen "EOFError, end of file reached" jos ringer_id==" "
      # Hakusana täytyy escapettaa.
      # -- pre 6.6.2009
      def find_by_ringer_id(ringer_id)
        ringer = find(CGI.escape("#{ringer_id}"))
        ringer = nil unless ringer.is_ringer? # result can be of any user type

        return ringer
      end

    end

    module InstanceMethods

      def is_ringer?
        not self.ringer_id.blank?
      end

      # Active Resource does not convert "string booleans" to real booleans.
      def is_admin?
        self.is_admin == "true"
      end

    end

  end
  
end