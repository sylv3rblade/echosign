module Echosign::Request

  # Performs REST create_agreement operation
  #
  # @param body [Hash] Request body  (REQUIRED)
  # @param token [String] Auth token  (REQUIRED)
  # @param user_id [String] Echosign user ID  (REQUIRED)
  # @param user_email [String] Echosign user email
  # @return [Hash] Agreement response body
  def self.create_agreement(body, token, user_id=nil, user_email=nil)
    headers = { 'Access-Token' => token }
    headers.merge!('X-User-Id' => user_id) unless user_id.nil?
    headers.merge!('X-User-Email' => user_email) unless user_email.nil?
    response = post(ENDPOINT.fetch(:agreement), body, headers, json:true)
    JSON.parse(response.body)
  end

  # Performs REST GET /agreements operation
  #
  # @param token [String] Auth Token
  # @return [Hash] Agreements response body
  def self.get_agreements(token)
    headers = { 'Access-Token' => token }
    response = get(ENDPOINT.fetch(:agreement), headers)
    JSON.parse(response.body)
  end

  # Performs REST GET /agreement/:id operation
  #
  # @param token [String] Auth Token
  # @param agreement_id [String] ID of agreement to retrieve info on.
  # @return [Hash] Agreement info response body
  def self.agreement_info(token, agreement_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:agreement)}/#{agreement_id}"
    response = get(endpoint, headers)
    JSON.parse(response.body)
  end

  # Performs REST GET /agreement/:id/signingUrls operation
  #
  # @param token [String] Auth Token
  # @param agreement_id [String] ID of agreement to retrieve info on.
  # @return [Hash] URL information for the eSign page of the agreement
  def self.agreement_signing_urls(token, agreement_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:agreement)}/#{agreement_id}/signingUrls"
    response = get(endpoint, headers)
    JSON.parse(response.body)
  end

  # Gets a single combined PDF document for the documents associated with an agreement.
  #
  # @param token [String] Auth Token
  # @param agreement_id [String] ID of agreement to retrieve info on.
  # @return [String] Raw bytes from document file
  def self.agreement_combined_pdf(token, agreement_id, versionId, participantEmail, attachSupportingDocuments, auditReport)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:agreement)}/#{agreement_id}/combinedDocument"
    endpoint << add_query(endpoint, "versionId=#{versionId}") unless versionId.nil?
    endpoint << add_query(endpoint, "participantEmail=#{participantEmail}") unless participantEmail.nil?
    endpoint << add_query(endpoint, "attachSupportingDocuments=#{attachSupportingDocuments}")
    endpoint << add_query(endpoint, "auditReport=#{auditReport}")
    response = get(endpoint, headers)
  end

  # Retrieves data entered by the user into interactive form fields at the time they signed the agreement
  #
  # @param token [String] Auth Token
  # @param agreement_id [String]  (REQUIRED)
  # @return [String] Raw bytes representing CSV file
  def self.agreement_form_data(token, agreement_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:agreement)}/#{agreement_id}/formData"
    response = get(endpoint, headers)
  end

  # Retrieve agreement document PDF
  #
  # @param token [String] Auth Token
  # @param agreement_id [String] ID of agreement to retrieve info on.
  # @return [String] Raw bytes from document file
  def self.agreement_document_file(token, agreement_id, document_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:agreement)}/#{agreement_id}/documents/#{document_id}"
    response = get(endpoint, headers)
  end

  # Performs REST GET /agreement/:id/auditTrail operation
  #
  # @param token [String] Auth Token
  # @param agreement_id [String] ID of agreement to retrieve info on.
  # @return [String] Raw bytes from audit pdf file
  def self.audit_trail_pdf(token, agreement_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:agreement)}/#{agreement_id}/auditTrail"
    response = get(endpoint, headers)
  end

  # Performs REST GET /agreement/:id/documents
  #
  # @param agreement_id [String] (REQUIRED)
  # @param recipient_email [String] The email address of the participant to be used to retrieve documents. (REQUIRED)
  # @param format [String] Content format of the supported documents. It can have two possible values ORIGINAL or CONVERTED_PDF. (REQUIRED)
  # @param version_id [String] Version of the agreement as provided by {agreement_info agreement_info}.  If not provided, the latest version of the agreement is used.
  # @return [Hash] Agreement documents response body
  def self.agreement_documents(token, agreement_id, recipient_email=nil, format=nil, version_id=nil)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:agreement)}/#{agreement_id}/documents"
    endpoint << add_query(endpoint, "versionId=#{version_id}") unless version_id.nil?
    endpoint << add_query(endpoint, "participantEmail=#{recipient_email}") unless version_id.nil?
    endpoint << add_query(endpoint, "supportingDocumentContentFormat=#{format}") unless format.nil?
    response = get(endpoint, headers)
    JSON.parse(response.body)
  end


  # Performs REST PUT /agreement/:id operation
  #
  # @param token [String] Auth Token
  # @param agreement_id [String] ID of agreement to retrieve info on.
  # @param request_body [Hash] Hash for Agreement status update
  # @return [Hash] Agreements response body
  def self.update_agreement_status(token, agreement_id, request_body)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:agreement)}/#{agreement_id}/status"

    begin
      response = HTTParty.put(
        endpoint,
        request_body.to_json,
        headers
      )
    rescue Exception => error
      raise_error(error)
    end

    JSON.parse(response.body)
  end


end
