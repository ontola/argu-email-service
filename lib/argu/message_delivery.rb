# frozen_string_literal: true

module Argu
  class MessageDelivery < ActionMailer::MessageDelivery
    private

    def processed_mailer
      @processed_mailer ||= @mailer_class.new(@args.shift).tap do |mailer|
        mailer.process @action, *@args
      end
    end
  end
end
