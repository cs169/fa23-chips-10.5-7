# frozen_string_literal: true

When /^(?:|I )select state "([^"]*)"$/ do |state_name|
  find("[data-state-name='#{state_name}']").click
end
