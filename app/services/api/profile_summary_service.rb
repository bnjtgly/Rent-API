module Api
  class ProfileSummaryService
    attr_accessor :user, :property, :flatmate, :cover_letter

    def initialize(user, property, flatmate, cover_letter)
      @user = user
      @property = property
      @flatmate = flatmate
      @cover_letter = cover_letter
    end

    def call
      {
        cover_letter: @cover_letter,
        property: get_property,
        personal_info: get_personal_info,
        addresses: get_addresses,
        identities: get_identities,
        incomes: get_incomes,
        employment: get_employment,
        pets: get_pets,
        flatmates: @flatmate ? get_flatmates : []
      }
    end

    private
    def get_property
      {
        property_id: @property.id,
        agency_id: @property.agency_id,
        details: @property.details
      }
    end
    def get_personal_info
      {
        email: @user.email,
        complete_name: @user.complete_name,
        gender: @user.ref_gender.display,
        date_of_birth: @user.date_of_birth_format,
        phone: @user.phone,
        mobile_number: @user.mobile_number
      }
    end

    def get_addresses(address = [], address_details = {})
      @user.addresses.each_with_object({}) do |data|
        address_details[:id] = data.id
        address_details[:user_id] = data.user_id
        address_details[:state] = data.state
        address_details[:suburb] = data.suburb
        address_details[:address] = data.address
        address_details[:post_code] = data.post_code
        address_details[:valid_from] = data.valid_from
        address_details[:valid_thru] = data.valid_thru
        if data.reference
          address_details[:reference] = {
            id: data.reference.id,
            address_id: data.reference.address_id,
            full_name: data.reference.full_name,
            email: data.reference.email,
            position: data.reference.ref_ref_position.display,
            mobile_country_code: data.reference.ref_mobile_country_code.display,
            mobile: data.reference.mobile
          }
        else
          address_details[:reference] = nil
        end
        address << address_details
        address_details = {}
      end

      address
    end

    def get_identities(identities = [], identities_details = {})
      @user.identities.each do |data |
        identities_details[:id] = data.id
        identities_details[:user_id] = data.user_id
        identities_details[:identity_type] = data.ref_identity_type.display
        identities_details[:id_number] = data.id_number
        identities_details[:file] = data.file.url

        identities << identities_details
        identities_details = {}
      end

      identities
    end

    def get_incomes(incomes = [], incomes_details = {})
      total_income_summary ||= Api::IncomeService.new(@user.incomes).call

      @user.incomes.each do |data|
        incomes_details[:id] = data.id
        incomes_details[:user_id] = data.user_id
        incomes_details[:income_source] = data.ref_income_source.display
        incomes_details[:income_frequency] = data.ref_income_frequency.display
        incomes_details[:currency] = data.ref_currency.display
        incomes_details[:amount] = data.amount
        incomes_details[:proof] = data.proof.url

        incomes << incomes_details
        incomes_details = {}
      end

      {
        total_income_summary: total_income_summary,
        data: incomes
      }
    end

    def get_employment(employment = {})
      @employment = @user.incomes.where.associated(:employment).first
      return [] unless @employment

      @employment = @employment.employment

      employment[:id] = @employment.id
      employment[:income_id] = @employment.income_id
      employment[:company_name] = @employment.company_name
      employment[:position] = @employment.position
      employment[:tenure] = @employment.tenure
      employment[:state] = @employment.state
      employment[:suburb] = @employment.suburb
      employment[:address] = @employment.address
      employment[:post_code] = @employment.post_code
      if @employment.emp_documents
        documents = []
        @employment.emp_documents.each do |doc|
          documents << {
            id: doc.id,
            employment_id: doc.employment_id,
            document_type_id: doc.document_type_id,
            file: doc.file.url
          }
        end
        employment[:documents] = documents
      else
        employment[:documents] = nil
      end

      employment
    end

    def get_pets(pets = [], pets_details = {})
      @user.pets.each do |data|
        pets_details[:id] = data.id
        pets_details[:user_id] = data.user_id
        pets_details[:pet_type] = data.ref_pet_type.display
        pets_details[:pet_gender] = data.ref_pet_gender.display
        pets_details[:pet_weight] = data.ref_pet_weight.display
        pets_details[:name] = data.name
        pets_details[:breed] = data.breed
        pets_details[:color] = data.color
        if data.pet_vaccinations
          vaccination = []
          data.pet_vaccinations.each do |vaccine|
            vaccination << {
              pet_vaccination_id: vaccine.id,
              pet_id: vaccine.pet_id,
              pet_vaccine_type: vaccine.ref_pet_vaccine_type.display,
              vaccination_date: vaccine.vaccination_date,
              proof: vaccine.proof.url
            }
          end
          pets_details[:vaccination] = vaccination
        else
          pets_details[:vaccination] = nil
        end
        pets << pets_details
        pets_details = {}
      end
      pets
    end

    def get_flatmates(flatmates = [], flatmates_details= {})
      @user.flatmates.each_with_object({}) do |data, |
        flatmates_details[:id] = data.id
        flatmates_details[:group_name] = data.group_name
        if data.flatmate_members
          members = []
          data.flatmate_members.each do |mem|
            members << {
              id: data.id,
              user_id: mem.user.id,
              email: mem.user.email,
              first_name: mem.user.first_name,
              last_name: mem.user.last_name,
              complete_name: mem.user.complete_name,
              date_of_birth: mem.user.date_of_birth_format,
              gender: mem.user.ref_gender.display,
              phone: mem.user.phone,
              mobile_number: mem.user.mobile_number,
              avatar: mem.user.avatar.url
            }
          end
          flatmates_details[:members] = members
        else
          flatmates_details[:members] = nil
        end
        flatmates << flatmates_details
        flatmates_details= {}
      end

      flatmates
    end
      
  end
end
