class s2p.Documentation
  constructor: (options) ->
    @sectionClass = options.sectionClass
    @pageClass    = options.pageClass
    if @sectionClass
      @setNavigationSection()

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

$ ->
  s2p.docs = new s2p.Documentation(s2p)
