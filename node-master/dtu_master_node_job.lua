local taskname = "Received Message Task"
log.info(taskname, "start")
local channelID = 1
PronetStopProRecCh(1)
function notifyAvailableStatus()
    local stateChangeData = {}
    stateChangeData.state = "available"
    stateChangeData.expirationTime = "null"
    stateChangeData.from = "master-node"
    local encodedJSONData = json.encode(stateChangeData)
    local preparedStateChangeTransmitData = {}
    preparedStateChangeTransmitData[1] = "1/status"
    preparedStateChangeTransmitData[2] = encodedJSONData
    PronetSetSendCh(channelID, preparedStateChangeTransmitData)
end

function notifyPaymentByTopic(imei, price)
    local preparedTopicAndData = {}
    local publishConfirmTopicName = imei .. "/payment"
    local machinePriceData = {}
    machinePriceData.price = price
    machinePriceData.message = "Successful"
    local encodedJSONPriceData = json.encode(machinePriceData)

    preparedTopicAndData[1] = publishConfirmTopicName
    preparedTopicAndData[2] = encodedJSONPriceData

    PronetSetSendCh(channelID, preparedTopicAndData)
end

while true do
    local netr = PronetGetRecChAndDel(channelID)
    local sender
    local sms
    local retryQuerySMS = 1
    if netr then
        log.info(taskname, "data received: ", netr)
        local serializedJsonData, _, _ = json.decode(netr)
        if serializedJsonData then
            log.info("json", "decode imei", serializedJsonData.imei)
            log.info("json", "decode price", serializedJsonData.price)

            _, sender, sms = sys.waitUntil("SMS_INC", 80000)
            log.info("sender is ", sender)

            while (sender ~= "KBank" and sender ~= nil) do
                log.info("Retry to query SMS ", retryQuerySMS)
                if retryQuerySMS == 3 then
                    break
                end
                sender, sms = sys.waitUntil("SMS_INC", 20000)
                retryQuerySMS = retryQuerySMS + 1
            end

            if sms then
                local isMatachedPrice = string.find(sms, serializedJsonData.price)
                local isMatachedText = string.find(sms, "เงินเข้า")
                log.info("sms", "received", sms)
                if (isMatachedPrice and isMatachedText) then
                    notifyPaymentByTopic(serializedJsonData.imei, serializedJsonData.price)
                end
            else
                log.info("No message found")
            end
            sys.wait(1000)
            notifyAvailableStatus()
        end
    end
    sys.wait(1000)
end
