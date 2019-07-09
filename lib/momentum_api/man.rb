
module MomentumApi
  class Man

    attr_reader :discourse, :user_client, :user_details, :users_categories
    attr_accessor :is_owner

    def initialize(discourse, user_client, user_details, mock: nil)
      raise ArgumentError, 'user_client needs to be defined' if user_client.nil?
      raise ArgumentError, 'user_details needs to be defined' if user_details.nil? || user_details.empty?

      @discourse          =   discourse
      @mock               =   mock

      @user_details       =   user_details
      @user_client        =   user_client

      begin
        @users_categories = @user_client.categories
        @mock ? sleep(0) : sleep(1)
      rescue DiscourseApi::UnauthenticatedError
        @users_categories = nil
        @discourse.options[:logger].warn "#{user_details['username']} : DiscourseApi::UnauthenticatedError - Not permitted to view resource."
      rescue DiscourseApi::TooManyRequests
        @discourse.options[:logger].warn 'Sleeping for 20 seconds ....'
        @mock ? sleep(0) : sleep(20)
        @users_categories = @user_client.categories
      end

      @is_owner = false

    end


    def run

      if @discourse.options[:issue_users].include?(@user_details['username'])
        puts "#{@user_details['username']} in scan_contexts"
      end

      # Examine Users Groups and Cagegories
      @user_details['groups'].each do |group|
        
        if @discourse.options[:issue_users].include?(@user_details['username'])
          puts "\n#{@user_details['username']}  with group: #{group['name']}\n"
        end

        # Group Cases
        @discourse.schedule.group_cases(self, group)

        # Category Cases
        if @users_categories and @discourse.schedule.options[:category]
          @discourse.schedule.category_cases(self, group)
        else
          # puts "\nSkipping Category Cases for #{@user_details['username']}.\n"
        end

      end

      # Once per User Cases
      if @discourse.schedule.options[:user]
        @discourse.schedule.user_cases(self)
      end

    end


    def print_user_options(user_details, user_option_print, user_label='UserName', pos_5=user_details[user_option_print[5].to_s], updated_option: nil)

      field_settings = "%-18s %-14s %-16s %-12s %-12s %-17s %-14s %-14s"

      if updated_option
        updated_value = user_details
        updated_option.each {|level| updated_value = updated_value[level]}
      else
        updated_value = nil
      end

      heading = sprintf field_settings, user_label,
                        user_option_print[0], user_option_print[1], user_option_print[2],
                        user_option_print[3], user_option_print[4], user_option_print[5], updated_option

      body = sprintf field_settings, user_details['username'],
             user_details[user_option_print[0].to_s].to_s[0..9], user_details[user_option_print[1].to_s].to_s[0..9],
             user_details[user_option_print[2].to_s], user_details[user_option_print[3].to_s],
             user_details[user_option_print[4].to_s], pos_5, updated_value
      @discourse.options[:logger].info heading
      @discourse.options[:logger].info body
    end

  end
end
