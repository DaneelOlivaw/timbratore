require 'gtk2'
require 'rubygems'
require 'active_record'
require "mysql"
require 'net/ftp'

ActiveRecord::Base.establish_connection(
	:adapter => "mysql",
	:host => "localhost",
	:username => "user",
	:password => "password",
	:database => "stamping"
)

class Stamps < ActiveRecord::Base
	belongs_to :user, :class_name =>"Users"
end

class Users < ActiveRecord::Base
	has_many :stamp
end

def delete_event( widget, event )
	return false
end

def destroy( widget )
	Gtk.main_quit
end

def avviso
	avviso = Gtk::MessageDialog.new(@window, Gtk::Dialog::DESTROY_WITH_PARENT, Gtk::MessageDialog::WARNING, Gtk::MessageDialog::BUTTONS_CLOSE, "Scusa, ma chi saresti?")
	@password.text = ""
	avviso.run
	avviso.destroy
end

def conferma
	avviso = Gtk::MessageDialog.new(@window, Gtk::Dialog::DESTROY_WITH_PARENT, Gtk::MessageDialog::WARNING, Gtk::MessageDialog::BUTTONS_CLOSE, "Ciao, #{@nome}, hai trimbrato correttamente.")
	avviso.run
	@password.text = ""
	avviso.destroy
end

Gtk.init

	@window = Gtk::Window.new( Gtk::Window::TOPLEVEL)
	@window.window_position=(Gtk::Window::POS_CENTER_ALWAYS)
	@window.set_default_size(600, 600)
	@window.set_title( "Timbratore" )
	@window.signal_connect( "delete_event" ) {
		delete_event( nil, nil )
	}
	@window.signal_connect( "destroy" ) {
		destroy( nil )
	}

	box1 = Gtk::VBox.new(false, 10)
	box2 = Gtk::HBox.new(false, 10)
	box1.pack_start(box2, false, false, 10)
	@window.add(box1)

	etichetta = Gtk::Label.new("Scrivi la password e premi 'Timbra'o il tasto 'Invio'")

	@password = Gtk::Entry.new()
	@password.max_length=(10)
	@password.visibility=(false)
	@password.signal_connect("activate") {
		timbra
	}

	botttimbra = Gtk::Button.new( "Timbra" )
	botttimbra.signal_connect("clicked") {
		timbra
	}

	def timbra
		utente = Users.find(:all, :conditions => "password = '#{@password.text}'")
		if utente.length == 0
			avviso
		else
			@nome = utente[0].nome
			Stamps.create(:matricola => "#{utente[0].matricola}", :users_id => "#{utente[0].id}")
			conferma
		end
	end

	bottinvia = Gtk::Button.new( "Invia dati" )
	bottinvia.signal_connect("clicked") {
		filecsv = File.new("esportacsv.csv", "w+")
		timbratura = Stamps.find(:all)
		timbratura.each do |t|
			filecsv.puts("#{t.id}" + ";" + "#{t.users_id}" + ";" + "#{t.matricola}"+ ";" + "#{t.ora.strftime('%Y-%m-%d %H:%M:%S')}")
		end
		filecsv.close

		ftp = Net::FTP.new('ftp.sito.it')
	  ftp.login(user = "user", password = "password")
  	destinazione = ftp.chdir('tabelle')
  	ftp.puttextfile('esportacsv.csv', 'esportacsv.csv')
  	ftp.close
	}

	bottchiudi = Gtk::Button.new( "Esci" )
	bottchiudi.signal_connect("clicked") {
		@window.destroy
	}

	box2.pack_start(etichetta, false, false, 10)
	box2.pack_start(@password, false, false, 10)
	box1.pack_start(botttimbra, false, false, 10)
	box1.pack_start(bottinvia, false, false, 10)
	box1.pack_start(bottchiudi, false, false, 10)
	@window.show_all
Gtk.main
