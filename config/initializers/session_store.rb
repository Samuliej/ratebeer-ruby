# Redis ei halunnut toimia helpolla, joten talletetaan
# sessio data tietokantaan
Rails.application.config.session_store :active_record_store, key: '_ratebeer_session'
