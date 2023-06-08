require 'csv'

# UserAccount class
class UserAccount
  @@user_id = 0

  attr_reader :balance

  def initialize(name, acc_number, pin, expiry_date, balance)
    verify_acc_number(acc_number)
    @name = name
    @acc_number = acc_number
    @pin = pin
    @expiry_date = expiry_date
    @balance = balance
    @@user_id = CSV.read('user_accounts.csv').length + 1
    write_to_csv
  end

  def verify_acc_number(acc_number)
    if File.exist?('user_accounts.csv')
      CSV.foreach('user_accounts.csv') do |row|
        if row[2] == acc_number.to_s
          raise "Account number already exists"
        end
      end
    end
  end

  def write_to_csv
    CSV.open('user_accounts.csv', 'a') do |csv|
      csv << [@@user_id, @name, @acc_number, @pin, @expiry_date, @balance]
    end
  end

  # Display user account details
  def display_account_details
    puts "Name: #{@name}"
    puts "ATM number: #{@acc_number}"
    puts "PIN: #{@pin}"
    puts "Expiry date: #{@expiry_date}"
    puts "Balance: #{@balance}"
  end

  def self.no_of_accounts
    @@user_id
  end

  # Verify pin
  def verify_pin(pin)
      @pin == pin.to_s
    end
  end
  # Withdraw money from account
  private
  def withdraw_money(amount)
    @balance -= amount
    puts "You have withdrawn #{amount}. Your new balance is #{@balance}"
  end



# ATM_Machine class
class ATM_Machine
  @@atm_id = 0

  def initialize(location, cash_available)
    @location = location
    @cash_available = cash_available
    @@atm_id = CSV.read('atm_machine.csv').length + 1
    write_to_csv
  end

  def write_to_csv
    CSV.open('atm_machine.csv', 'a') do |csv|
      csv << [@@atm_id, @location, @cash_available]
    end
  end

  # Functions for ATM interface
  def menu(user_account)
    puts "Welcome to the ATM"
    puts "Please enter your pin: "
    pin = gets.chomp.to_i
    if user_account.verify_pin(pin)
      puts "1. Withdraw money"
      puts "2. Check balance"
      puts "3. Exit"
      puts "Enter your choice: "
      choice = gets.chomp.to_i
      case choice
      when 1
        puts "Enter amount to withdraw: "
        amount = gets.chomp.to_i
        withdraw_money_from_account(user_account, amount)
      when 2
        puts "Your balance is #{user_account.balance}"
      when 3
        puts "Thank you for using the ATM"
      else
        puts "Invalid choice"
      end
    else
      puts "Invalid pin"
    end
  end

  def self.no_of_machines
    @@atm_id
  end

  private
  def withdraw_money_from_account(user_account, amount)
    if @cash_available >= amount && user_account.balance >= amount
      user_account.send(:withdraw_money, amount)
      @cash_available -= amount
      puts "Withdrawal successful. Updated cash available: #{@cash_available}"
    else
      puts "Insufficient funds or cash availability"
    end
  end
end

# Main application
user_account = UserAccount.new("John Doe", "123456789", "1234", "2025-06-01", 1000)
atm_machine = ATM_Machine.new("New York", 5000)
atm_machine.menu(user_account)
