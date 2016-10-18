module Accela
  class ReportAPI < APIGroup
    as_class_method :create_report

    def create_report(id: nil, module_name: nil, fields: {})
      unless id && module_name
        raise BadRequestError.new("Must supply ID and module_name")
      end
      query = { module: module_name}
      payload = { parameters: fields }
      Accela::V4::CreateReport.new(config).call(id, query, payload)
    end
  end
end
