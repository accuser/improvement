require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require_relative '../lib/improvement'
require_relative '../apps/api/application'

Hanami.configure do
  mount Api::Application, at: '/apv/v1'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/improvement_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/improvement_development'
    #    adapter :sql, 'mysql://localhost/improvement_development'
    #
    adapter :sql, ENV.fetch('DATABASE_URL')

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root 'lib/improvement/mailers'

    # See http://hanamirb.org/guides/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: http://hanamirb.org/guides/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :info, formatter: :json, filter: []

    mailer do
      delivery :smtp, address: ENV.fetch('SMTP_HOST'), port: ENV.fetch('SMTP_PORT')
    end
  end
end
