require "spec_helper"

describe QuestionHelper do
  today = Date.today

  describe "#get_from_date_to_date" do
  end

  #~ describe "#calculate_date" do
    #~ it "must return right date different" do
      #~ diff = helper.calculate_date(today,today + 10.days)
      #~ expect(diff).to eq 10
    #~ end
  #~ end

  #~ describe "#get_chart_type" do
    #~ params = {from_date: today}
    #~ it "must return bar chat for 0 - 7 days" do
      #~ params[:to_date] = today + 6.days
      #~ chart_type = helper.get_chart_type(nil, params)
      #~ expect(chart_type).to eq "bar_chart"
    #~ end

    #~ it "must line chart for 8 - 31 days" do
      #~ params[:to_date] = today + 11.days
      #~ chart_type = helper.get_chart_type(nil, params)
      #~ expect(chart_type).to eq "line_chart"
    #~ end

    #~ it "must line chart from 32 to infinity" do
      #~ params[:to_date] = today + 41.days
      #~ chart_type = helper.get_chart_type(nil, params)
      #~ expect(chart_type).to eq "line_chart"
    #~ end
  #~ end

  describe "#get_question_status_class" do
    it "must return active when Active is passed" do
      status = "Active"
      result = helper.get_question_status_class(status)
      expect(result).to eq "active"
    end

    it "must return active when Closed is passed" do
      status = "Closed"
      result = helper.get_question_status_class(status)
      expect(result).to eq "closed"
    end
  end

  describe "#get_category_based_icon" do
    it "must return bullhorn when Marketting is given" do
      icon = helper.get_category_based_icon "Marketing"
      expect(icon).to eq "bullhorn"
    end

    it "must return bullhorn when Feedback is given" do
      icon = helper.get_category_based_icon "Feedback"
      expect(icon).to eq "user"
    end

    it "must return bullhorn when Feedback is given" do
      icon = helper.get_category_based_icon "Innovation"
      expect(icon).to eq "flash"
    end

  end

  describe "#dynamic_icon_category" do
    it "must return 'glyphicon glyphicon-user' when Feedback is given" do
      result = helper.dynamic_icon_category "Feedback"
      expect(result).to eq 'glyphicon glyphicon-user'
    end

    it "must return 'glyphicon glyphicon-flash' when Innovation is given" do
      result = helper.dynamic_icon_category "Innovation"
      expect(result).to eq 'glyphicon glyphicon-flash'
    end

    it "must return 'glyphicon glyphicon-bullhorn' when Marketing is given" do
      result = helper.dynamic_icon_category "Marketing"
      expect(result).to eq 'glyphicon glyphicon-bullhorn'
    end
  end

  #~ describe "#get_from_date_to_date" do
    #~ from_date = Date.today
    #~ to_date = from_date + 10.days
    #~ it "must return date in right format" do
      #~ result = helper.get_from_date_to_date from_date, to_date, nil, nil, "day"
      #~ format = "%Y/%m/%d"
      #~ expect(result).to eq [from_date.strftime(format), to_date.strftime(format), format]
    #~ end

    #~ it "must return date in right format" do
      #~ result = helper.get_from_date_to_date from_date, to_date, nil, nil, "month"
      #~ format = "%Y/%m"
      #~ expect(result).to eq [from_date.strftime(format), to_date.strftime(format), format]
    #~ end

    #~ it "must return date in right format" do
      #~ result = helper.get_from_date_to_date from_date, to_date, nil, nil, "year"
      #~ format = "%Y"
      #~ expect(result).to eq [from_date.strftime(format), to_date.strftime(format), format]
    #~ end
  #~ end
end