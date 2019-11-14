# require_relative 'log/ib/momentum_api/utility'
require '../lib/momentum_api'

discourse_options = {
    do_live_updates:        false,
    # target_username:        'Kim_Miller',         # Samartha_Swaroop Steve_Scott Scott_StGermain Kim_Miller David_Ashby Fernando_Venegas
    target_groups:          %w(trust_level_0),      # LaunchpadVI OpenKimono TechMods GreatX BraveHearts LaunchpadVI trust_level_0 trust_level_1
    ownership_groups:       %w(Owner Owner_Manual),
    instance:               'https://discourse.gomomentum.org',
    api_username:           'KM_Admin',
    exclude_users:           %w(js_admin Winston_Churchill sl_admin JP_Admin admin_sscott RH_admin KM_Admin MD_Admin),
    issue_users:             %w(),
    logger:                  momentum_api_logger
}

# groups are 45: Onwers_Manual, 136: Owners (auto), 107: FormerOwners (expired), 108: MomentumInterested
schedule_options = {
    ownership:{
        settings: {
            all_ownership_group_ids: [45, 136]
        },
        manual: {
            # old_memberful_found: {
            #     do_task_update:         true,
            #     user_fields:            '6',
            #     ownership_code:         'MO',
            #     days_until_renews:      9999,
            #     action_sequence:        'R1',
            #     # add_to_group:           45,
            #     # remove_from_group:      107,
            #     message_to:             nil,
            #     message_cc:             'KM_Admin',
            #     message_from:           'Kim_Miller',
            #     excludes:               %w()
            # },
            trial_new_found: {
                do_task_update:         true,
                user_fields:            '6',
                ownership_code:         'TM',
                days_until_renews:      9999,
                action_sequence:        'R0',
                add_to_group:           45,
                remove_from_group:      107,
                message_to:             nil,
                message_cc:             'KM_Admin',
                message_from:           'Kim_Miller',
                excludes:               %w()
            },
            trial_expires_next_week: {
                do_task_update:         true,
                user_fields:            '6',
                ownership_code:         'TM',
                days_until_renews:      7,
                action_sequence:        'R1',
                add_to_group:           nil,
                remove_from_group:      nil,
                message_from:           'Kim_Miller',
                excludes:               %w()
            },
            trial_expired_today: {
                do_task_update:         true,
                user_fields:            '6',
                ownership_code:         'TM',
                days_until_renews:      0,
                action_sequence:        'R2',
                add_to_group:           nil,
                remove_from_group:      nil,
                message_from:           'Kim_Miller',
                excludes:               %w()
            },
            trial_final: {
                do_task_update:         true,
                user_fields:            '6',
                ownership_code:         'TM',
                days_until_renews:      -7,
                add_to_group:           107,
                remove_from_group:      45,
                action_sequence:        'R3',
                message_cc:             'KM_Admin',
                message_from:           'Kim_Miller',
                excludes:                 %w()
            },
            new_user_found: {
                do_task_update:         true,
                user_fields:            '6',
                ownership_code:         'NU',
                days_until_renews:      9999,
                action_sequence:        'R0',
                add_to_group:           108,
                # remove_from_group:      107,
                message_to:             nil,
                message_cc:             'KM_Admin',
                message_from:           'Kim_Miller',
                excludes:               %w()
            },
            new_user_one_week_ago: {
                do_task_update:         true,
                user_fields:            '6',
                ownership_code:         'NU',
                days_until_renews:      -7,
                action_sequence:        'R1',
                add_to_group:           nil,
                remove_from_group:      nil,
                message_from:           'Kim_Miller',
                excludes:               %w()
            },
            new_user_two_weeks_ago: {
                do_task_update:         true,
                user_fields:            '6',
                ownership_code:         'NU',
                days_until_renews:      -14,
                action_sequence:        'R2',
                add_to_group:           nil,
                remove_from_group:      nil,
                message_from:           'Kim_Miller',
                excludes:               %w()
            },
            new_user_three_weeks_ago: {
                do_task_update:         true,
                user_fields:            '6',
                ownership_code:         'NU',
                days_until_renews:      -21,
                # add_to_group:           107,
                # remove_from_group:      45,
                action_sequence:        'R3',
                message_cc:             'KM_Admin',
                message_from:           'Kim_Miller',
                excludes:                 %w()
            }
        }
    }
}

discourse = MomentumApi::Discourse.new(discourse_options, schedule_options)
discourse.apply_to_users
discourse.scan_summary
