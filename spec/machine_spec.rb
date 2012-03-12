require 'spec_helper'

describe Machine do
	before :each do
		@machine=Machine.new 5,"ip","name","cpu"
	end
	describe "#new" do
		it "returns a new Machine object" do
			@machine.should be_an_instance_of Machine
		end
		it "Argument Error when given fewer arguments" do
			lambda {Machine.new "id" "ip"}.should raise_exception ArgumentError
		end
	end
	describe "#ip" do
		it "return the correct ip address" do
			@machine.getIp.should == "ip"
		end
	end
	describe "#id" do
                it "return the correct ip address" do
                        @machine.getId.should == 5
                end
        end
	describe "#name" do
                it "return the correct ip address" do
                        @machine.getName.should == "name"
                end
        end
	describe "#cpu" do
                it "return the correct ip address" do
                        @machine.getCpu.should == "cpu"
                end
        end
        describe "#save" do
		it "save a Machine object into database" do
			@machine.persistence.should == 5
			db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
			db_table = db[:machine] 
			db_table.filter(:id=>5).delete 			 
		end 
	end




end
