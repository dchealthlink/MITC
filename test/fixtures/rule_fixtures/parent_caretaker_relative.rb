##### GENERATED AT 2015-07-07 11:06:11 -0400 ######
class ParentCaretakerRelativeFixture < MagiFixture
  attr_accessor :magi, :test_sets

  def initialize
    super
    @magi = 'ParentCaretakerRelative'

    @parent = Applicant.new("Parent", {'Applicant Age' => 25 },'','','')
    @child = Applicant.new("Child", {'Applicant Age' => 6 },'','','')
    @household = Household.new('Household', [ @parent, @child ] )
    @tax_return = TaxReturn.new( [@parent], [@child], {} )

    @test_sets = [
      {
        test_name: "Parent Caretaker - Applicant Child List is Empty", 
        inputs: {
          "Person ID" => "Parent",
          "Person List" => @parent,
          "Physical Household" => Household.new('Solo Household', [@parent]),
          "Tax Returns" => [TaxReturn.new([@parent], [],nil) ],
          "Applicant Age" => 25,
          "Applicant Relationships" => [Relationship.new(@parent, :self, '')]
        },
        configs: {
          "Child Age Threshold" => 19,
          "Dependent Age Threshold" => 19,
          "Option Dependent Student" => "N",
          "Deprivation Requirement Retained" => "N",
          "Option Caretaker Relative Relationship" => "00",
          "State Unemployed Standard" => 100
        },
        expected_outputs: {
          "Applicant Parent Caretaker Category Indicator" => "N",
          "Parent Caretaker Category Ineligibility Reason" => 146,
          "Qualified Children List" => []
        }
      },
      {
        test_name: "Parent Caretaker - Child Qualifies",
        inputs: {
          "Person ID" => "Parent",
          "Person List" => [@parent, @child],
          "Physical Household" => @household,
          "Tax Returns" => [ @tax_return ],
          "Applicant Age" => 25,
          "Applicant Relationships" => [Relationship.new(@parent, :self, ''), Relationship.new(@child, :child, '')]
        },
        configs: {
          "Child Age Threshold" => 19,
          "Dependent Age Threshold" => 19,
          "Option Dependent Student" => "N",
          "Deprivation Requirement Retained" => "N",
          "Option Caretaker Relative Relationship" => "00",
          "State Unemployed Standard" => 100
        },
        expected_outputs: {
          "Applicant Parent Caretaker Category Indicator" => "N",
          "Parent Caretaker Category Ineligibility Reason" => 146,
          "Qualified Children List" => []
        }
      },

      {
        test_name: "Bad Info - Inputs",
        inputs: {
          "Applicant Relationships" => []
        },
        configs: {
          "Child Age Threshold" => 19,
          "Dependent Age Threshold" => 19,
          "Option Dependent Student" => "N",
          "Deprivation Requirement Retained" => "N",
          "Option Caretaker Relative Relationship" => "00",
          "State Unemployed Standard" => 100
        },
        expected_outputs: {
        }
      },
      {
        test_name: "Bad Info - Configs",
        inputs: {
          "Person ID" => 1,
          "Person List" => [],
          "Physical Household" => [],
          "Tax Returns" => [],
          "Applicant Age" => 25,
          "Applicant Relationships" => []
        },
        configs: {
          "State Unemployed Standard" => 100
        },
        expected_outputs: {
        }
      }
    ]
  end
end


# NOTES
# leaving this for later because it's super complicated. -CF 7/7/2015


# "Applicant Parent Caretaker Category Indicator" => "N",
# "Parent Caretaker Category Ineligibility Reason" => 146,
# "Qualified Children List" => ?
