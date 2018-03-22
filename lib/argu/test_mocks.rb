# frozen_string_literal: true

module TestMocks
  include UrlHelper

  def not_found_mock(url)
    stub_request(:get, url).to_return(status: 404)
  end

  def valid_user_mock(id, language = 'nl')
    stub_request(:get, argu_url("/u/user#{id}"))
      .to_return(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: {
          data: {
            id: argu_url("/u/user#{id}"),
            type: 'users',
            attributes: {
              display_name: "User#{id}",
              url: "user#{id}",
              email: "user#{id}@example.com",
              language: language
            },
            relationships: {
              profilePhoto: {
                data: {
                  id: 'https://argu.dev/media_objects/1',
                  type: 'schema:ImageObject'
                }
              }
            }
          },
          included: [
            {
              id: 'https://argu.dev/media_objects/1',
              type: 'schema:ImageObject',
              attributes: {
                thumbnail: 'https://argu.dev/photo.png'
              }
            }
          ]
        }.to_json
      )
  end

  def group_mock(id)
    stub_request(:get, argu_url("/g/#{id}"))
      .to_return(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: {
          data: {
            id: id,
            type: 'groups',
            attributes: {
              display_name: "Group#{id}"
            },
            relationships: {
              organization: {
                data: {
                  id: 'https://argu.dev/o/2',
                  type: 'pages'
                },
                links: {
                  self: {
                    meta: {
                      '@type': 'schema:organization'
                    }
                  },
                  related: {
                    href: 'https://argu.dev/o/1',
                    meta: {
                      attributes: {
                        '@id': 'https://argu.dev/o/1',
                        '@type': 'schema:Organization',
                        '@context': {
                          schema: 'http://schema.org/',
                          title: 'schema:name'
                        },
                        title: 'Argu'
                      }
                    }
                  }
                }
              }
            }
          },
          included: [
            {
              id: 'https://argu.dev/o/2',
              type: 'pages',
              attributes: {
                '@type': 'schema:Organization',
                potentialAction: nil,
                displayName: 'Argu'
              },
              links: {
                self: 'https://argu.dev/o/2'
              }
            }
          ]
        }.to_json
      )
  end
end
