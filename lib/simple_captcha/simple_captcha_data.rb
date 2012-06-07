module SimpleCaptcha
  class SimpleCaptchaData
    include Mongoid::Document
    include Mongoid::Timestamps
    include ActiveModel::Translation

    field :value, :type => String
    field :key, :type => String
    
    validates :key, :length => {  :maximum => 40 }, :presence => true
    validates :value, :length => {  :maximum => 6}, :presence => true
    attr_accessible :key, :value
    
    class << self
      def get_data(key)
        data = where(:key => key).first || new(:key => key)
      end

      def remove_data(key)
        where(:key => key).destroy_all
        clear_old_data(1.hour.ago)
      end

      def clear_old_data(time = 1.hour.ago)
        return unless Time === time
        where(:updated_at.lt => time).destroy_all
      end
    end
  end
end
