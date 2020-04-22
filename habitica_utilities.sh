#!/usr/bin/env bash
authorId="8b819da9-81e7-42e4-992e-cd1a9c3a823b"
baseUrl="https://habitica.com/api/v3"

makeRequest() {
    if [ "$2" == "GET" ]
    then
        curl "${baseUrl}/${1}" -s -X GET --compressed \
            -H "Content-Type: application/json" \
            -H "x-api-user: ${HABIT_ID}" \
            -H "x-api-key: ${HABIT_KEY}" \
            -H "x-client: ${authorID}"
    fi
    if [ "$2" == "POST" ] && [ -z "$3" ]
    then
        curl "${baseUrl}/${1}" -s -X POST \
            -H "Content-length: 0" \
            -H "Content-Type: application/json" \
            -H "x-api-user: ${HABIT_ID}" \
            -H "x-api-key: ${HABIT_KEY}" \
            -H "x-client: ${authorID}"
    fi

}

checkQuest() {
    details=$(makeRequest "groups/party" "GET")
    status=$(echo "$details" | jq .data.quest.key)
    active=$(echo "$details" | jq .data.quest.active)
    if [ "$active" == "true" ] && [ -n "$status" ]
    then
        echo "No new quests"
        exit
    else
        acceptQuest
    fi
}

acceptQuest(){
    makeRequest "groups/party/quests/accept" "POST"
}

if [ "$1" == 'quest' ]
then
    checkQuest
fi
