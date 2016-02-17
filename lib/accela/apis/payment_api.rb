module Accela
  class PaymentAPI < APIGroup
    as_class_method :create_payment, :initialize_payment

    def create_payment(input)
      raw = input.is_a?(Hash) ? input : input.raw
      payload = PaymentTranslator.ruby_to_json([raw])
      payment_response_hash  = Accela::V4::CreatePayment.result(payload.first)
      #input_hash = PaymentTranslator.json_to_ruby([payment_hash]).first
      #Payment.create(input_hash)      
    end

    # https://developer.accela.com/docs/api_reference/V4.post.payments.initialize.html
    def initialize_payment(record_id, merchant_account_id)
      Accela::V4::InitializePayment.call(
        "entityIds" => [record_id],
        "entityType" => "Record",
        "paymentMethod" => "Credit Card",
        "merchantAccountId" => merchant_account_id
      )
    end
  end
end
