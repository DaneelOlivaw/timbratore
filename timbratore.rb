require 'gtk2'
require 'rubygems'
require 'active_record'
require "mysql"
require 'net/ftp'

#mysqldump -u root -pnew-password timbratore timbratures > prova

ActiveRecord::Base.establish_connection(
	:adapter => "mysql",
	:host => "localhost",
	:username => "root",
	:password => "new-password",
	:database => "timbratore"
)

class Timbratures < ActiveRecord::Base
	belongs_to :utenti, :class_name => "Utentis"
end

class Utentis < ActiveRecord::Base
	has_many :timbrature
end

def delete_event( widget, event )
	return false
end

def destroy( widget )
	puts "distrutto"
	Gtk.main_quit
end

def avviso
	avviso = Gtk::MessageDialog.new(@window, Gtk::Dialog::DESTROY_WITH_PARENT, Gtk::MessageDialog::WARNING, Gtk::MessageDialog::BUTTONS_CLOSE, "Scusa, ma chi saresti?")
	@password.text = ""
#	@@password.select
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

	@window = Gtk::Window.new( Gtk::Window::TOPLEVEL) #, Gtk::Widget::CAN_DEFAULT ) #, Gtk::Position::POS_CENTER_ALWAYS )
	@window.window_position=(Gtk::Window::POS_CENTER_ALWAYS)
	@window.set_default_size(600, 600)
#	@window.maximize
#	@window.flags=(Gtk::Widget::CAN_DEFAULT) #has_focus = (true))
	@window.set_title( "timbratore" )

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

	etichetta = Gtk::Label.new("Scrivi la @password e premi '@timbra'")

	botttimbra = Gtk::Button.new( "Timbra" )

	@password = Gtk::Entry.new()
	@password.max_length=(10)
	@password.visibility=(false)

	@password.signal_connect("activate") {
		puts "BU!"
		timbra
	}


#	puts @@password.activates_default
	botttimbra.signal_connect("clicked") {
		timbra
	}

	def timbra
		utente = Utentis.find(:all, :conditions => "password = '#{@password.text}'")
		if utente.length == 0
			avviso
		else
			@nome = utente[0].nome
			Timbratures.create(:matricola => "#{utente[0].matricola}", :utentis_id => "#{utente[0].id}")
			conferma
		end
	end

	filecsv = File.new("./Scrivania/esportacsv.csv", "w+")
	bottinvia = Gtk::Button.new( "Invia dati" )
	bottinvia.signal_connect("clicked") {
=begin
		estraitabella = "mysqldump -u root -pnew-@password timbratore timbratures > prova2"
 		system(estraitabella)
=end
	timbratura = Timbratures.find(:all)
	timbratura.each do |t|
		filecsv.puts("#{t.id}" + ";" + "#{t.utentis_id}" + ";" + "#{t.matricola}"+ ";" + "#{t.ora.strftime('%Y-%m-%d %H:%M:%S')}")
	end
	filecsv.close
=begin
		ftp = Net::FTP.new('ftp.coopnoi.it')
	  ftp.login(user = "coopnoi", @password = "baksiawWev6")
  	destinazione = ftp.chdir('tabelle')
#  files = ftp.list('n*')
  	ftp.puttextfile('prova2', 'prova2')
  	ftp.close
=end
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
