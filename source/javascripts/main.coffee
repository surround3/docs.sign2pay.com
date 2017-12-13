class s2p.Documentation
  constructor: (options) ->
    @api_endpoint = 'http://app.sign2pay.com/'
    @sectionClass = options.sectionClass
    @pageClass    = options.pageClass
    if @sectionClass
      @setNavigationSection()

    if @sectionClass == 'integrations' && @pageClass == 'approaches'
      @bindAuthorizationCodeModal()

    @bindSMSDemos()
    @hideToDos()

  setNavigationSection: =>
    if @sectionClass?
      $("li.doc_section .pages").removeClass("in")
      section = $("li.doc_section[data-section='#{@sectionClass}'] .pages")
      section
      .addClass("in")

      if @pageClass?
        section
        .find(".#{@pageClass}")
        .addClass("active")
      else
        $("li.doc_section[data-section='#{@sectionClass}']")
        .find("a.overview")
        .addClass("active")

  hideToDos: =>
    $(".todo").hide()

  bindSMSDemos: =>
    $("#submit_sms_button").on "click", (e) =>

      button = new window.spinkitButton(el:$(e.currentTarget))

      if $('#phone').val() != ""
        @hijackSMSForm()
      else
        $(".sk-spinner").remove();
        $('span.sk-text').show();

      return false

    $('#submit_sms_form').on "submit", (e)=>
      false

    $('#display_phone').on 'keyup change', ->
      intlNumber = undefined
      intlNumber = $('#display_phone').intlTelInput('getNumber')
      $('#phone').val intlNumber
      return

    $('#display_phone').intlTelInput
      defaultCountry: 'auto'
      onlyCountries: @countries
      geoIpLookup: (callback) ->
        $.get('https://ipinfo.io?token=b10555a836c3e0', (->
        ), 'jsonp').always (resp) ->
          countryCode = undefined
          countryCode = if resp and resp.country then resp.country else ''
          callback countryCode

  hijackSMSForm: =>
    form = $('#submit_sms_form')
    options =
      url   : form.attr("action")
      data  : form.serialize()
      type  : "POST"

    $.ajax(options)
      .success (data)=>
        window.sms_id = data.id;
        if window.sms_id?
          @pollForState();
          $('#submit_sms_button .sk-text').text(data.state);
          $(".sk-spinner").remove();
          $('span.sk-text').show();
        else
          $('#submit_sms_button .sk-text').text('Sorry - SMS Failed');
          $(".sk-spinner").remove();
          $('span.sk-text').show();

      .error () =>
        console.log(error);
        $('#submit_sms_button .sk-text').text('SMS Failed');
        $(".sk-spinner").remove();
        $('span.sk-text').show();

  pollForState: =>
    console.log "check state"
    options = {
      type: "GET",
      url: "https://authature.com/sms/" + window.sms_id
    }

    $.ajax(options)
      .done (data)=>
        console.log data.state
        $('#submit_sms_button .sk-text').text data.state
        if data.state != "paid"
          window.setTimeout @pollForState, 5000

  bindAuthorizationCodeModal: =>

    renderPanel = (type, head, body) ->
      "<div class=\"panel panel-#{type}\">" +
      "<div class=\"panel-heading\"><h3 class=\"panel-title\">#{head}</h3></div>" +
      "<div class=\"panel-body\">#{body}</div>" +
      "</div>"

    renderStatus = (json, error) ->
      if error
        renderPanel('danger', json.error, json.error_description)
      else
        renderPanel('success', 'Authroization Code', "Your authorization code is <strong>#{json.code}")

    renderResponseTab = (url, json, error) ->
      html = renderStatus(json, error) +
        "<h4>Request URL:</h4>" +
        "<pre><code>#{url}</code></pre>" +
        "<h4>Response JSON:</h4>" +
        "<pre><code>#{JSON.stringify(json, undefined, 2)}</code></pre>"
      $('#authorization_code_output').html(html);
      $('#authroization_code_modal .nav-tabs a[href=#authorization_code_output]').tab('show');

    $("#authroization_code_modal #send_request_button").on "click", (e) =>

      options =
        url      : @api_endpoint + 'oauth/no-authorize' + '?' + $('#authroization_code_modal form').serialize()
        dataType : 'json'
        type     : "POST"

      $.ajax(options)
        .success (data) ->
          renderResponseTab(@url, data, false);

        .error (xhr) ->
          renderResponseTab(@url, xhr.responseJSON, true)

      return true;

$ ->
  s2p.docs = new s2p.Documentation(s2p)
