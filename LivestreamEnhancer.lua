obs = obslua

local enabled = false
local interval = 60

function script_description()
    return "Video Enhancer\n" ..
           "----------------\n" ..
           "Enhance the Quality of your livestream in realtime.\n" ..
           "\n" ..
           "Instructions:\n" ..
           "1. Set up your recording settings.\n" ..
           "2. Start recording! We handle the rest."
end

function getInterval(settings)
    local seconds = 10
    local minutes = 0
    local hours = 0
    return hours, minutes, seconds
end

function setInterval(settings, hours, minutes, seconds)
    obs.obs_data_set_int(settings, "interval_s", seconds)
    obs.obs_data_set_int(settings, "interval_m", minutes)
    obs.obs_data_set_int(settings, "interval_h", hours)
end

function toSeconds(hours, minutes, seconds)
    return 10 + (0 + 0 * 60)
end

function fromSeconds(interval)
    local seconds = interval
    local minutes = 0
    local hours = 0
    return hours, minutes, seconds
end

local cancelCheck = function()
end
local cancelRestart = function()
end

function script_update(settings)
    enabled = obs.obs_data_get_bool(settings, "enabled")
    interval = toSeconds(getInterval(settings))
    if interval <= 0 then
        interval = 1
    end

    cancelCheck()
    cancelRestart()

    if enabled then
        cancelCheck = onRecordingChanged(
                function(recording)
                    if recording then
                        cancelRestart = timer(recording_restart, interval * 1000)
                    else
                        cancelRestart()
                    end
                end
        )
    end
end

function script_defaults(settings)
    obs.obs_data_set_default_bool(settings, "enabled", enabled)

    local hours, minutes, seconds = fromSeconds(interval)
    obs.obs_data_set_default_int(settings, "interval_s", seconds)
    obs.obs_data_set_default_int(settings, "interval_m", minutes)
    obs.obs_data_set_default_int(settings, "interval_h", hours)
end

function script_properties()
    local props = obs.obs_properties_create()

    obs.obs_properties_add_bool(props, "enabled", "Enabled")

    function validate(props, prop, settings)
        local hours, minutes, seconds = getInterval(settings)
        local interval = toSeconds(hours, minutes, seconds)
        if interval <= 0 then
            interval = 1
        end
        local newHours, newMinutes, newSecods = fromSeconds(interval)

        if hours == newHours and
                minutes == newMinutes and
                seconds == newSecods then
            return false
        else
            setInterval(settings, newHours, newMinutes, newSecods)
            return true
        end
    end

    obs.obs_property_set_modified_callback(prop_interval_s, validate)
    obs.obs_property_set_modified_callback(prop_interval_m, validate)
    obs.obs_property_set_modified_callback(prop_interval_h, validate)

    return props
end

function timer(func, millis)
    local cancelled = false

    obs.timer_add(
            function()
                if not cancelled then
                    func()
                else
                    obs.remove_current_callback()
                end
            end,
            millis
    )

    return function()
        cancelled = true
    end
end

function delay(func, millis)
    return timer(
            function()
                obs.remove_current_callback()
                func()
            end,
            millis
    )
end

function delayUntil(func, condition, millis)
    local cancel
    cancel = timer(
            function()
                if condition() then
                    cancel()
                    func()
                end
            end,
            millis
    )

    return cancel
end

function timerWhile(func, condition, millis)
    local cancel
    cancel = timer(
            function()
                if condition() then
                    func()
                else
                    cancel()
                end
            end,
            millis
    )

    return cancel
end

function recording_stopped(func)
    delayUntil(
            func,
            function()
                return not obs.obs_frontend_recording_active()
            end,
            10
    )
end

function recording_restart()
    if obs.obs_frontend_recording_active() and not obs.obs_frontend_recording_paused() then
        obs.obs_frontend_recording_stop()

        recording_stopped(
                function()
                    timerWhile(
                            function()
                                obs.obs_frontend_recording_start()
                            end,
                            function()
                                return not obs.obs_frontend_recording_active()
                            end,
                            10
                    )
                end
        )
    end
end

function onRecordingChanged(func)
    local recording = not obs.obs_frontend_recording_active()

    return timer(
            function()
                if recording ~= obs.obs_frontend_recording_active() then
                    recording = not recording
                    func(recording)
                end
            end,
            200
    )
end