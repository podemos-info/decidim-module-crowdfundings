# frozen_string_literal: true

shared_examples 'manage collaborations' do
  let(:valid_until) { (DateTime.now + 2.months).strftime('%Y-%m-%d') }

  context 'creates a new collaboration' do
    before do
      find('.card-title a.button').click
    end

    it 'with invalid data' do
      within '.new_collaboration' do
        fill_in :collaboration_minimum_custom_amount, with: 1_000
        select '100.00 €', from: :collaboration_default_amount
        find('*[type=submit]').click
      end

      within '.callout-wrapper' do
        expect(page).to have_content('Check the form data and correct the errors')
      end

      expect(page).to have_content('NEW COLLABORATION CAMPAIGN')
    end

    it 'with valid data' do
      fill_in_i18n(
        :collaboration_title,
        '#collaboration-title-tabs',
        en: 'My collaboration',
        es: 'Mi colaboración',
        ca: 'La meua col·laboració'
      )

      fill_in_i18n_editor(
        :collaboration_description,
        '#collaboration-description-tabs',
        en: 'My collaboration description',
        es: 'La descripción de la colaboración',
        ca: 'La descripció de la col·laboració'
      )

      fill_in :collaboration_minimum_custom_amount, with: 1_000
      fill_in :collaboration_target_amount, with: 100_000
      select '100.00 €', from: :collaboration_default_amount
      find(:xpath, "//input[@id='collaboration_active_until']", visible: false).set valid_until

      within '.new_collaboration' do
        find('*[type=submit]').click
      end

      within '.callout-wrapper' do
        expect(page).to have_content('successfully')
      end

      within 'table' do
        expect(page).to have_content('My collaboration')
      end
    end
  end

  context 'updates a collaboration' do
    before do
      within find('tr', text: translated(collaboration.title)) do
        page.find('a.action-icon--edit').click
      end
    end

    it 'with invalid data' do
      within '.edit_collaboration' do
        fill_in :collaboration_target_amount, with: ''
        find('*[type=submit]').click
      end

      within '.callout-wrapper' do
        expect(page).to have_content('Check the form data and correct the errors')
      end

      expect(page).to have_content('EDIT COLLABORATION CAMPAIGN')
    end

    it 'with valid data' do
      within '.edit_collaboration' do
        fill_in_i18n(
          :collaboration_title,
          '#collaboration-title-tabs',
          en: 'My updated collaboration',
          es: 'Mi colaboración actualizada',
          ca: 'La meua col·laboració actualitzada'
        )

        fill_in_i18n_editor(
          :collaboration_description,
          '#collaboration-description-tabs',
          en: 'My updated collaboration description',
          es: 'La descripción de la colaboración actualizada',
          ca: 'La descripció de la col·laboració actualitzada'
        )

        fill_in :collaboration_minimum_custom_amount, with: 1_500
        fill_in :collaboration_target_amount, with: 150_000
        select '50.00 €', from: :collaboration_default_amount
        find(:xpath, "//input[@id='collaboration_active_until']", visible: false).set ''

        find('*[type=submit]').click
      end

      within '.callout-wrapper' do
        expect(page).to have_content('successfully')
      end

      within 'table' do
        expect(page).to have_content('My updated collaboration')
      end
    end
  end

  context 'deleting a collaboration' do
    let!(:collaboration2) { create(:collaboration, feature: current_feature) }

    before do
      visit current_path
    end

    it 'deletes a collaboration' do
      within find('tr', text: translated(collaboration2.title)) do
        accept_confirm { page.find('a.action-icon--remove').click }
      end

      within '.callout-wrapper' do
        expect(page).to have_content('successfully')
      end

      within 'table' do
        expect(page).to have_no_content(translated(collaboration2.title))
      end
    end
  end

  context 'previewing collaborations' do
    it 'allows the user to preview the collaboration' do
      within find('tr', text: translated(collaboration.title)) do
        @new_window = window_opened_by { find('a.action-icon--preview').click }
      end

      within_window @new_window do
        expect(current_path).to eq resource_locator(collaboration).path
        expect(page).to have_content(translated(collaboration.title))
      end
    end
  end
end
