module.exports = require("express3-handlebars")
  defaultLayout: "layout"
  helpers:
    answerInput: () ->
      switch this.response_type__c
        when "Text"
          """
            <input type="text" name="questions[#{this.sfid}]" autocorrect="off" autocapitalize="off">
          """

        when "Boolean"
          """
            <div class="radio">
              <input type="radio" name="questions[#{this.sfid}]" value="T" id="#{this.sfid}-T">
              <label for="#{this.sfid}-T">True</label>
            </div>

            <div class="radio">
              <input type="radio" name="questions[#{this.sfid}]" value="F" id="#{this.sfid}-F">
              <label for="#{this.sfid}-F">False</label>
            </div>
          """

        when "Radio"
          this.answers.map((answer, i) =>
            id = this.sfid + "-" + i
            """
              <div class="radio">
                <input type="radio" name="questions[#{this.sfid}]" value="#{answer.answer__c}" id="#{id}">
                <label for="#{id}">#{answer.answer__c}</label>
              </div>
            """
          ).join("\n")

        when "Picklist"
          options = this.answers.map((answer, i) =>
            id = this.sfid + "-" + i
            """
              <option value="#{answer.answer__c}">#{answer.answer__c}</option>
            """
          ).join("\n")
          """
            <select name="questions[#{this.sfid}]">#{options}</select>
          """

