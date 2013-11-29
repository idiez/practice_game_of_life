Given(/^the following setup$/) do |table|
  # table is a Cucumber::Ast::Table 
  @grid = Grid.new(table.raw)
end

When(/^I evolve the board$/) do
  @grid.evolve
end

Then(/^the center cell should be dead$/) do
  @grid.is_center_alive?.should eq false 
end

Then(/^the center cell should be alive$/) do
  @grid.is_center_alive?.should eq true
end

Then(/^I should see the following board$/) do |table|
  @grid.raw.should eq table.raw
end
