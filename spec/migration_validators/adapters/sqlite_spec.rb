require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

Driver = Class.new(MigrationValidators::Adapters::Base)

describe MigrationValidators::Adapters::Sqlite, :type => :mv_test do
  before :all do
    use_db :adapter => "sqlite3",  :pool => 5, :timeout => 5000, :database => "validation_migration_test_db"
    
    db.initialize_schema_migrations_table
    ::ActiveRecord::Migration.verbose = false
  end

  before :each do
    MigrationValidators::Core::DbValidator.clear_all
  end

  for_test_table do

    #integer
    for_integer_column  do
      with_validator :presence do
        with_option :as => :trigger do
          it { is_expected.to allow(5) }
          it { is_expected.to deny(nil).with_initial(5) }
        end

        with_option :allow_blank => true do
          it { is_expected.to allow(nil) }
        end

        with_option :allow_nil => true do
          it { is_expected.to allow(nil) }
        end

        with_option :on => :update do
          it { is_expected.to allow.insert(nil) }
        end

        with_option :on => :create do
          it { is_expected.to allow.update(nil).with_initial(5) }
        end
      end

      with_validator :inclusion do
        with_option :as => :trigger do
          #closed integer interval
          with_options :in => 1..9 do
            it { is_expected.to allow(1,4,9) }
            it { is_expected.to deny(0, 10).with_initial(1) }
          end

          #open integer interval
          with_options :in => 1...9 do
            it { is_expected.to allow(1,4) }
            it { is_expected.to deny(0, 9, 10).with_initial(1) }
          end

          #single value
          with_options :in => 9 do
            it { is_expected.to allow(9) }
            it { is_expected.to deny(8, 10).with_initial(9) }
          end

          #array
          with_options :in => [1, 9] do
            it { is_expected.to allow(1, 9) }
            it { is_expected.to deny(0, 3, 10).with_initial(1) }
          end

          with_options :in => 9, :message => "Some error message" do
            it { is_expected.to deny(8, 10).with_initial(9).and_message(/Some error message/) }

            with_option :on => :update do
              it { is_expected.to allow.insert(8, 10) }
            end

            with_option :on => :create do
              it { is_expected.to allow.update(8, 10).with_initial(9) }
            end
          end
        end
      end

      with_validator :exclusion do
        with_option :as => :trigger do
          #closed integer interval
          with_options :in => 1..9 do
            it { is_expected.to allow(0, 10) }
            it { is_expected.to deny(1,4,9).with_initial(0) }
          end

          #open integer intervalw
          with_options :in => 1...9 do
            it { is_expected.to allow(0, 9, 10) }
            it { is_expected.to deny(1,4).with_initial(0) }
          end

          #single value
          with_options :in => 9 do
            it { is_expected.to allow(8, 10) }
            it { is_expected.to deny(9).with_initial(0) }
          end

          #array
          with_options :in => [1, 9] do
            it { is_expected.to allow(0, 3, 10) }
            it { is_expected.to deny(1, 9).with_initial(0) }
          end

          with_options :in => 9, :message => "Some error message" do
            it { is_expected.to deny(9).with_initial(8).and_message(/Some error message/) }

            with_option :on => :update do
              it { is_expected.to allow.insert(9) }
            end

            with_option :on => :create do
              it { is_expected.to allow.update(9).with_initial(8) }
            end
          end

        end
      end

      with_validator :uniqueness do
        with_option :as => :trigger do
          it { is_expected.to deny.insert.at_least_one(1,1)}
          it { is_expected.to deny.update(1).with_initial(1,2)}
          it { is_expected.to allow.insert(1,2,3) }

          with_option :message => "Some error message" do
            it { is_expected.to deny.at_least_one(1,1).with_initial(1).and_message(/Some error message/) }
          end 
        end

        with_option :as => :index do
          it { is_expected.to deny.insert.at_least_one(1,1).with_message(/is not unique/) }
          it { is_expected.to deny.update(1).with_initial(1,2).and_message(/is not unique/) }
          it { is_expected.to allow.insert(1,2,3) }
          it { is_expected.to allow.update(1).with_initial(2) }
        end
      end
    end

    for_integer_column :validates => {:uniqueness => {:as => :index, :message => "Some error message"}, :inclusion => {:in => 1..9, :as => :trigger, :message => "Some error message"}} do
      it { is_expected.to deny.at_least_one(1,1).with_initial(1, 2).and_message(/is not unique/) }
      it { is_expected.to deny(10).with_initial(8).and_message(/Some error message/) }

      with_change :inclusion => false do
        it { is_expected.to deny.at_least_one(1,1).with_initial(1, 2).and_message(/is not unique/) }
        it { is_expected.to allow(10) }
      end

      with_change :inclusion => {:in => 1..9} do
        with_change :inclusion => false do
          it { is_expected.to allow(10) }
        end
      end
    end

    for_integer_column :validates => {:uniqueness => {:as => :index, :message => "Some error message"}, :exclusion => {:in => 4..9, :as => :trigger, :message => "Some error message"}} do
      it { is_expected.to deny.at_least_one(1,1).with_initial(1, 2).and_message(/is not unique/) }
      it { is_expected.to deny(9).with_initial(10).and_message(/Some error message/) }

      with_change :exclusion => false do
        it { is_expected.to deny.at_least_one(1,1).with_initial(1, 2).and_message(/is not unique/) }
        it { is_expected.to allow(9) }
      end

      with_change :exclusion => {:in => 4..9} do
        with_change :exclusion => false do
          it { is_expected.to allow(9) }
        end
      end
    end

    for_integer_column :validates => {:uniqueness => {:as => :index, :message => "Some error message"}, :presence => {:as => :trigger, :message => "Some error message"}} do
      it { is_expected.to deny.at_least_one(1,1).with_initial(1, 2).and_message(/is not unique/) }
      it { is_expected.to deny(nil).with_initial(10).and_message(/Some error message/) }

      with_change :presence => false do
        it { is_expected.to deny.at_least_one(1,1).with_initial(1, 2).and_message(/is not unique/) }
        it { is_expected.to allow(nil) }
      end

      with_change :presence => true do
        with_change :presence => false do
          it { is_expected.to allow(nil) }
        end
      end
    end


    #float
    for_float_column do

      with_validator :presence do
        with_option :as => :trigger do
          it { is_expected.to allow(1.1) }
          it { is_expected.to deny(nil).with_initial(1.1) }
        end

        with_option :allow_blank => true do
          it { is_expected.to allow(nil) }
        end

        with_option :allow_nil => true do
          it { is_expected.to allow(nil) }
        end

        with_option :on => :update do
          it { is_expected.to allow.insert(nil) }
        end

        with_option :on => :create do
          it { is_expected.to allow.update(nil).with_initial(1.1) }
        end
      end

      with_validator :inclusion do
        with_option :as => :trigger do
          #closed integer interval
          with_options :in => 1.1..9.1 do
            it { is_expected.to allow(1.1, 9.1) }
            it { is_expected.to deny(1.0, 9.2).with_initial(1.1) }
          end

          #open integer interval
          with_options :in => 1.1...9.1 do
            it { is_expected.to allow(1.1, 9) }
            it { is_expected.to deny(1.0, 9.1, 9.2).with_initial(1.1) }
          end

          #single value
          with_options :in => 9.1 do
            it { is_expected.to allow(9.1) }
            it { is_expected.to deny(8.1, 10.1).with_initial(9.1) }
          end

          #array
          with_options :in => [1.1, 9.1] do
            it { is_expected.to allow(1.1, 9.1) }
            it { is_expected.to deny(0.1, 3.1, 10.1).with_initial(1.1) }
          end

          with_options :in => 9.1, :message => "Some error message" do
            it { is_expected.to deny(8.1, 10.1).with_initial(9.1).and_message(/Some error message/) }
          end
        end
      end

      with_validator :exclusion do
        with_option :as => :trigger do
          #closed integer interval
          with_options :in => 1.1..9.1 do
            it { is_expected.to allow(1.0, 9.2) }
            it { is_expected.to deny(1.1, 9.1).with_initial(1.0) }
          end

          #open integer interval
          with_options :in => 1.1...9.1 do
            it { is_expected.to allow(1.0, 9.1, 9.2) }
            it { is_expected.to deny(1.1, 9).with_initial(1.0) }
          end

          #single value
          with_options :in => 9.1 do
            it { is_expected.to deny(9.1).with_initial(9.0) }
            it { is_expected.to allow(8.1, 10.1) }
          end

          #array
          with_options :in => [1.1, 9.1] do
            it { is_expected.to deny(1.1, 9.1).with_initial(1.0) }
            it { is_expected.to allow(0.1, 3.1, 10.1) }
          end

          with_options :in => 9.1, :message => "Some error message" do
            it { is_expected.to deny(9.1).with_initial(9.0).and_message(/Some error message/) }
          end
        end
      end
    end

    #string
    for_string_column do
      with_validator :presence do
        with_option :as => :trigger do
          it { is_expected.to allow('b') }
          it { is_expected.to deny(nil).with_initial('b') }
        end

        with_option :allow_blank => true do
          it { is_expected.to allow(nil) }
        end

        with_option :allow_nil => true do
          it { is_expected.to allow(nil) }
        end

        with_option :on => :update do
          it { is_expected.to allow.insert(nil) }
        end

        with_option :on => :create do
          it { is_expected.to allow.update(nil).with_initial('b') }
        end
      end

      with_validator :uniqueness do
        with_option :as => :trigger do
          it { is_expected.to deny.at_least_one(' ', ' ').with_initial(' ', 'a') }

          with_option :allow_blank => true do
            it { is_expected.to allow(' ', ' ') }
          end
        end
      end

      with_validator :inclusion do
        with_option :as => :trigger do
          #closed string interval
          with_options :in => 'b'..'e' do
            it { is_expected.to allow('b', 'd', 'e') }
            it { is_expected.to deny('a', 'f').with_initial('b') }
            it { is_expected.to deny(' ').with_initial('b') }
            it { is_expected.to deny(nil).with_initial('b') }

            with_option :allow_blank => true do
              it { is_expected.to allow(' ') }
            end

            with_option :allow_nil => true do
              it { is_expected.to allow(nil) }
            end
          end

          #open string interval
          with_options :in => 'b'...'e' do
            it { is_expected.to allow('b', 'd') }
            it { is_expected.to deny('a', 'e', 'f').with_initial('b') }
            it { is_expected.to deny(' ').with_initial('b') }
            it { is_expected.to deny(nil).with_initial('b') }

            with_option :allow_blank => true do
              it { is_expected.to allow(' ') }
            end

            with_option :allow_nil => true do
              it { is_expected.to allow(nil) }
            end
          end

          #single string value
          with_options :in => 'b' do
            it { is_expected.to allow('b') }
            it { is_expected.to deny('a', 'c').with_initial('b') }
            it { is_expected.to deny(' ').with_initial('b') }
            it { is_expected.to deny(nil).with_initial('b') }

            with_option :allow_blank => true do
              it { is_expected.to allow(' ') }
            end

            with_option :allow_nil => true do
              it { is_expected.to allow(nil) }
            end
          end

          #array
          with_options :in => ['b', 'e'] do
            it { is_expected.to allow('b', 'e') }
            it { is_expected.to deny('a', 'c', 'f').with_initial('b') }
            it { is_expected.to deny(' ').with_initial('b') }
            it { is_expected.to deny(nil).with_initial('b') }

            with_option :allow_blank => true do
              it { is_expected.to allow(' ') }
            end

            with_option :allow_nil => true do
              it { is_expected.to allow(nil) }
            end
          end

          with_options :in => 'b'  do
            it { is_expected.to allow('b') }

            with_option :message => "Some error message" do
              it { is_expected.to deny('c').with_initial('b').with_message(/Some error message/) }
            end

            it { is_expected.to deny(' ').with_initial('b') }

            with_option :allow_blank => true do
              it { is_expected.to allow(' ') }
            end
          end
        end
      end

      with_validator :exclusion do
        with_option :as => :trigger do
          #closed string interval
          with_options :in => 'b'..'e' do
            it { is_expected.to allow('a', 'f') }
            it { is_expected.to deny('b', 'd', 'e').with_initial('a') }
            it { is_expected.to allow(nil) }
          end

          #open string interval
          with_options :in => 'b'...'e' do
            it { is_expected.to deny('b', 'd').with_initial('a') }
            it { is_expected.to allow('a', 'e', 'f') }
            it { is_expected.to allow(nil) }
          end

          #single string value
          with_options :in => 'b' do
            it { is_expected.to deny('b').with_initial('a') }
            it { is_expected.to allow('a', 'c') }
            it { is_expected.to allow(nil) }
          end

          #array
          with_options :in => ['b', 'e', ' '] do
            it { is_expected.to deny('b', 'e').with_initial('a') }
            it { is_expected.to allow('a', 'c', 'f') }
            it { is_expected.to deny(' ').with_initial('a') }
            it { is_expected.to allow(nil) }

            with_option :allow_blank => true do
              it { is_expected.to allow(' ') }
            end
          end

          with_options :in => 'b', :message => "Some error message" do
            it { is_expected.to deny('b').with_initial('a').with_message(/Some error message/) }
          end
        end
      end

      with_validator :length do
        with_option :as => :trigger do
          with_option :is => 5 do
            it {should allow('12345') }
            it {should deny('1234', '123456').with_initial('12345') }

            with_option :message => "Some error message" do
              it {should deny('123456').with_initial('12345').with_message("Some error message") }
              
              with_option :wrong_length => "Some specific error message" do
                it {should deny('123456').with_initial('12345').with_message("Some specific error message") }
              end
            end

            with_option :on => :create do
              it {should deny.insert('1234', '123456') }
              it {should allow.update('1234', '123456').with_initial('12345') }
            end

            with_option :on => :update do
              it {should allow.insert('1234', '123456') }
              it {should deny.update('1234', '123456').with_initial('12345') }
            end

            it {should deny(' ', nil).with_initial('12345') }
         
            with_option :allow_blank => true do
              it { is_expected.to allow.insert(' ') }
            end

            with_option :allow_nil => true do
              it { is_expected.to allow.insert(nil) }
            end
          end

          with_option :is => 0 do
            it { is_expected.to allow(nil) }
          end


          with_option :maximum => 5 do
            it {should allow('1234', '12345') }
            it {should deny('123456').with_initial('12345') }

            with_option :message => "Some error message" do
              it {should deny('123456').with_initial('12345').with_message("Some error message") }
              
              with_option :too_long => "Some specific error message" do
                it {should deny('123456').with_initial('12345').with_message("Some specific error message") }
              end
            end

            it { is_expected.to allow(' ', nil) }
          end

          with_option :minimum => 5 do
            it {should allow('12345', '123456') }
            it {should deny('1234').with_initial('12345') }

            with_option :message => "Some error message" do
              it {should deny('1234').with_initial('12345').with_message("Some error message") }
              
              with_option :too_short => "Some specific error message" do
                it {should deny('1234').with_initial('12345').with_message("Some specific error message") }
              end
            end

            it {should deny(' ', nil).with_initial('12345') }
         
            with_option :allow_blank => true do
              it { is_expected.to allow.insert(' ') }
            end

            with_option :allow_nil => true do
              it { is_expected.to allow.insert(nil) }
            end
          end

          with_option :minimum => 0 do
            it { is_expected.to allow(' ', nil) }
          end

          with_option :in => 2..5 do
            it {should allow('12', '123', '12345') }
            it {should deny('1', '123456').with_initial('12') }

            with_option :message => "Some error message" do
              it {should deny('1').with_initial('12').with_message("Some error message") }
            end

            it {should deny(' ', nil).with_initial('12') }
         
            with_option :allow_blank => true do
              it { is_expected.to allow.insert(' ') }
            end

            with_option :allow_nil => true do
              it { is_expected.to allow.insert(nil) }
            end
          end

          with_option :in => 0..1 do
            it { is_expected.to allow(' ', nil) }
          end

          with_option :in => 2...5 do
            it {should allow('12', '123') }
            it {should deny('1', '12345', '123456').with_initial('12') }

            with_option :message => "Some error message" do
              it {should deny('1').with_initial('12').with_message("Some error message") }
            end

            it {should deny(' ', nil).with_initial('12') }
         
            with_option :allow_blank => true do
              it { is_expected.to allow.insert(' ') }
            end

            with_option :allow_nil => true do
              it { is_expected.to allow.insert(nil) }
            end
          end

          with_option :in => 0...2 do
            it { is_expected.to allow(' ', nil) }
          end

          with_option :in => [2, 3, 5] do
            it {should allow('12', '123', '12345') }
            it {should deny('1', '1234', '123456').with_initial('12') }

            with_option :message => "Some error message" do
              it {should deny('1').with_initial('12').with_message("Some error message") }
            end

            it {should deny(' ', nil).with_initial('12') }
         
            with_option :allow_blank => true do
              it { is_expected.to allow.insert(' ') }
            end

            with_option :allow_nil => true do
              it { is_expected.to allow.insert(nil) }
            end
          end

          with_option :in => [0, 1] do
            it { is_expected.to allow(' ', nil) }
          end

          with_option :in => 5 do
            it {should allow('12345') }
            it {should deny('1234', '123456').with_initial('12345') }
          end

          with_option :within => 2..5 do
            it {should allow('12', '123', '12345') }
            it {should deny('1', '123456').with_initial('12') }

            with_option :message => "Some error message" do
              it {should deny('1').with_initial('12').with_message("Some error message") }
            end

            it {should deny(' ', nil).with_initial('12') }
         
            with_option :allow_blank => true do
              it { is_expected.to allow.insert(' ') }
            end

            with_option :allow_nil => true do
              it { is_expected.to allow.insert(nil) }
            end
          end

          with_option :within => 0..1 do
            it { is_expected.to allow(' ', nil) }
          end

          with_option :within => 2...5 do
            it {should allow('12', '123') }
            it {should deny('1', '12345', '123456').with_initial('12') }

            with_option :message => "Some error message" do
              it {should deny('1').with_initial('12').with_message("Some error message") }
            end

            it {should deny(' ', nil).with_initial('12') }
         
            with_option :allow_blank => true do
              it { is_expected.to allow.insert(' ') }
            end

            with_option :allow_nil => true do
              it { is_expected.to allow.insert(nil) }
            end
          end

          with_option :within => 0...2 do
            it { is_expected.to allow(' ', nil) }
          end

          with_option :within => [2, 3, 5] do
            it {should allow('12', '123', '12345') }
            it {should deny('1', '1234', '123456').with_initial('12') }

            with_option :message => "Some error message" do
              it {should deny('1').with_initial('12').with_message("Some error message") }
            end

            it {should deny(' ', nil).with_initial('12') }
         
            with_option :allow_blank => true do
              it { is_expected.to allow.insert(' ') }
            end

            with_option :allow_nil => true do
              it { is_expected.to allow.insert(nil) }
            end
          end

          with_option :within => [0, 1] do
            it { is_expected.to allow(' ', nil) }
          end

          with_option :within => 5 do
            it {should allow('12345') }
            it {should deny('1234', '123456').with_initial('12345') }
          end
        end
      end
    end

    for_string_column :validates => {:uniqueness => {:as => :index}, :length => {:in => 4..9, :as => :trigger, :message => "Some error message"}} do
      it { is_expected.to deny.at_least_one('1234','1234').with_initial('1234', '12345').and_message(/is not unique/) }
      it { is_expected.to deny('123').with_initial('1234').and_message(/Some error message/) }

      with_change :length => false do
        it { is_expected.to deny.at_least_one('1234','1234').with_initial('1234', '12345').and_message(/is not unique/) }
        it { is_expected.to allow('123') }
      end

      with_change :length => {:in => 4..9} do
        with_change :length => false do
          it { is_expected.to allow('123') }
        end
      end
    end

    #date
    for_date_column do
      startDate = Date.today - 5
      endDate = Date.today

      with_validator :presence do
        with_option :as => :trigger do
          it { is_expected.to allow(startDate) }
          it { is_expected.to deny(nil).with_initial(startDate) }
        end

        with_option :allow_blank => true do
          it { is_expected.to allow(nil) }
        end

        with_option :allow_nil => true do
          it { is_expected.to allow(nil) }
        end

        with_option :on => :update do
          it { is_expected.to allow.insert(nil) }
        end

        with_option :on => :create do
          it { is_expected.to allow.update(nil).with_initial(startDate) }
        end
      end

      with_validator :inclusion do
        with_option :as => :trigger do

          #closed date interval
          with_options :in => startDate..endDate do
            it { is_expected.to allow(startDate, endDate - 3, endDate) }
            it { is_expected.to deny(startDate - 1, endDate + 1).with_initial(endDate - 1) }
          end

          #open date interval
          with_options :in => startDate...endDate do
            it { is_expected.to allow(startDate, endDate - 3) }
            it { is_expected.to deny(startDate - 1, endDate, endDate + 1).with_initial(endDate - 1) }
          end

          #single date value
          with_options :in => endDate do
            it { is_expected.to allow(endDate) }
            it { is_expected.to deny(endDate - 1, endDate + 1).with_initial(endDate) }
          end

          #array
          with_options :in => [startDate, endDate] do
            it { is_expected.to allow(startDate, endDate) }
            it { is_expected.to deny(startDate - 1, endDate - 1, endDate + 1).with_initial(endDate) }
          end

          with_options :in => endDate, :message => "Some error message" do
            it { is_expected.to deny(endDate + 1).with_initial(endDate).with_message(/Some error message/) }
          end
        end
      end

      with_validator :exclusion do
        with_option :as => :trigger do

          #closed date interval
          with_options :in => startDate..endDate do
            it { is_expected.to deny(startDate, endDate - 3, endDate).with_initial(startDate - 1) }
            it { is_expected.to allow(startDate - 1, endDate + 1) }
          end

          #open date interval
          with_options :in => startDate...endDate do
            it { is_expected.to deny(startDate, endDate - 3).with_initial(startDate - 1) }
            it { is_expected.to allow(startDate - 1, endDate, endDate + 1) }
          end

          #single date value
          with_options :in => endDate do
            it { is_expected.to deny(endDate).with_initial(endDate - 1) }
            it { is_expected.to allow(endDate - 1, endDate + 1) }
          end

          #array
          with_options :in => [startDate, endDate] do
            it { is_expected.to deny(startDate, endDate).with_initial(startDate - 1) }
            it { is_expected.to allow(startDate - 1, endDate - 1, endDate + 1) }
          end

          with_options :in => endDate, :message => "Some error message" do
            it { is_expected.to deny(endDate).with_initial(endDate - 1).with_message(/Some error message/) }
          end
        end
      end
    end

    #time
    for_time_column do
      startTime = Time.now - 10
      endTime = Time.now

      with_validator :presence do
        with_option :as => :trigger do
          it { is_expected.to allow(startTime) }
          it { is_expected.to deny(nil).with_initial(startTime) }
        end

        with_option :allow_blank => true do
          it { is_expected.to allow(nil) }
        end

        with_option :allow_nil => true do
          it { is_expected.to allow(nil) }
        end

        with_option :on => :update do
          it { is_expected.to allow.insert(nil) }
        end

        with_option :on => :create do
          it { is_expected.to allow.update(nil).with_initial(startTime) }
        end
      end

      with_validator :inclusion do
        with_option :as => :trigger do

          #closed time interval
          with_options :in => startTime..endTime do
            it { is_expected.to allow(startTime, startTime + 1, endTime) }
            it { is_expected.to deny(startTime - 1, endTime + 1).with_initial(startTime) }
          end

          #open time interval
          with_options :in => startTime...endTime do
            it { is_expected.to allow(startTime, startTime + 1, endTime - 1) }
            it { is_expected.to deny(startTime - 1, endTime).with_initial(startTime) }
          end

          #single time value
          with_options :in => startTime do
            it { is_expected.to allow(startTime) }
            it { is_expected.to deny(startTime - 1, endTime).with_initial(startTime) }
          end

          #array
          with_options :in => [startTime, endTime] do
            it { is_expected.to allow(startTime, endTime) }
            it { is_expected.to deny(startTime - 1, startTime + 1, endTime + 1).with_initial(startTime) }
          end

          with_options :in => startTime, :message => "Some error message" do
            it { is_expected.to deny(startTime + 1).with_initial(startTime).with_message(/Some error message/) }
          end
        end
      end

      with_validator :exclusion do
        with_option :as => :trigger do

          #closed time interval
          with_options :in => startTime..endTime do
            it { is_expected.to deny(startTime, startTime + 1, endTime).with_initial(startTime - 1) }
            it { is_expected.to allow(startTime - 1, endTime + 1) }
          end

          #open time interval
          with_options :in => startTime...endTime do
            it { is_expected.to deny(startTime, startTime + 1, endTime - 1).with_initial(startTime - 1) }
            it { is_expected.to allow(startTime - 1, endTime) }
          end

          #single time value
          with_options :in => startTime do
            it { is_expected.to deny(startTime).with_initial(startTime - 1) }
            it { is_expected.to allow(startTime - 1, endTime) }
          end

          #array
          with_options :in => [startTime, endTime] do
            it { is_expected.to deny(startTime, endTime).with_initial(startTime - 1)  }
            it { is_expected.to allow(startTime - 1, startTime + 1, endTime + 1)}
          end

          with_options :in => startTime, :message => "Some error message" do
            it { is_expected.to deny(startTime).with_initial(startTime - 1).with_message(/Some error message/) }
          end
        end
      end
    end

    #datetime
    for_time_column do
      startDateTime = DateTime.now - 10
      endDateTime = DateTime.now

      with_validator :presence do
        with_option :as => :trigger do
          it { is_expected.to allow(startDateTime) }
          it { is_expected.to deny(nil).with_initial(startDateTime) }
        end

        with_option :allow_blank => true do
          it { is_expected.to allow(nil) }
        end

        with_option :allow_nil => true do
          it { is_expected.to allow(nil) }
        end

        with_option :on => :update do
          it { is_expected.to allow.insert(nil) }
        end

        with_option :on => :create do
          it { is_expected.to allow.update(nil).with_initial(startDateTime) }
        end
      end

      with_validator :inclusion do
        with_option :as => :trigger do

          #closed time interval
          with_options :in => startDateTime..endDateTime do
            it { is_expected.to allow(startDateTime, startDateTime + 1, endDateTime) }
            it { is_expected.to deny(startDateTime - 1, endDateTime + 1).with_initial(startDateTime) }
          end

          #open time interval
          with_options :in => startDateTime...endDateTime do
            it { is_expected.to allow(startDateTime, startDateTime + 1, endDateTime - 1) }
            it { is_expected.to deny(startDateTime - 1, endDateTime).with_initial(startDateTime) }
          end

          #single time value
          with_options :in => startDateTime do
            it { is_expected.to allow(startDateTime) }
            it { is_expected.to deny(startDateTime - 1, endDateTime).with_initial(startDateTime) }
          end

          #array
          with_options :in => [startDateTime, endDateTime] do
            it { is_expected.to allow(startDateTime, endDateTime) }
            it { is_expected.to deny(startDateTime - 1, startDateTime + 1, endDateTime + 1).with_initial(startDateTime) }
          end

          with_options :in => startDateTime, :message => "Some error message" do
            it { is_expected.to deny(startDateTime + 1).with_initial(startDateTime).with_message(/Some error message/) }
          end
        end
      end

      with_validator :exclusion do
        with_option :as => :trigger do

          #closed time interval
          with_options :in => startDateTime..endDateTime do
            it { is_expected.to deny(startDateTime, startDateTime + 1, endDateTime).with_initial(startDateTime - 1) }
            it { is_expected.to allow(startDateTime - 1, endDateTime + 1) }
          end

          #open time interval
          with_options :in => startDateTime...endDateTime do
            it { is_expected.to deny(startDateTime, startDateTime + 1, endDateTime - 1).with_initial(startDateTime - 1) }
            it { is_expected.to allow(startDateTime - 1, endDateTime) }
          end

          #single time value
          with_options :in => startDateTime do
            it { is_expected.to deny(startDateTime).with_initial(startDateTime - 1) }
            it { is_expected.to allow(startDateTime - 1, endDateTime) }
          end

          #array
          with_options :in => [startDateTime, endDateTime] do
            it { is_expected.to deny(startDateTime, endDateTime).with_initial(startDateTime - 1) }
            it { is_expected.to allow(startDateTime - 1, startDateTime + 1, endDateTime + 1) }
          end

          with_options :in => startDateTime, :message => "Some error message" do
            it { is_expected.to deny(startDateTime).with_initial(startDateTime - 1).with_message(/Some error message/) }
          end
        end
      end
    end
  end
end
