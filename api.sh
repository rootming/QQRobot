#!/bin/bash

#see https://metacpan.org/pod/distribution/Mojo-Webqq/doc/Webqq.pod#Mojo::Webqq::Plugin::Openqq

##信息获取
#/openqq/get_user_info           #查询用户信息
#/openqq/get_friend_info         #查询好友信息
#/openqq/get_group_info          #查询群信息
#/openqq/get_discuss_info        #查询讨论组信息
#/openqq/get_recent_info         #查询最近联系人列表信息
# 
##消息发送，均支持GET和POST
#/openqq/send_message            #发送好友消息 参数id=xxx&content=xxx 或 qq=xxx&content=xxx
#/openqq/send_group_message      #发送群消息   参数gid=xxx&content=xxx 或 gnumber=xxx&content=xxx
#/openqq/send_discuss_message    #发送讨论组消息 参数did=xxx&content=xxx （由于腾讯限制，当前无法成功发送）
#/openqq/send_sess_message       #发送群临时消息  参数 gid=xxx&id=xxx&content=xxx 或 gnumber=xxx&qq=xxx&content=xxx
#/openqq/send_sess_message       #发送讨论组临时消息 参数 did=xxx&id=xxx&content=xxx 或 did=xxx&qq=xxx&content=xxx

source config.sh
source env.sh

ROBOT_API="http://${ROBOT_ADDR}:${ROBOT_PORT}/openqq"

function execComand
{
    #eval $2=$(curl -s "${ROBOT_API}/$1")
    #COMMAND='curl -s ${ROBOT_API}/$1'
    #eval ${COMMAND}
    curl -s "${ROBOT_API}/$1"
    #echo $?
    if [ $? -ne 0 ]
    then
        showState "Exec \"${ROBOT_API}/$1\" failed."
        return 233
    fi
}

function getJson
{
    result=`execComand $1`
    #echo ${result}
    if [ "${result}" != "233" ]
    then
        echo ${result} | jq -c "$2" | tr -d "\""
    fi
}

function showState
{
    echo $1
}

function updateUserInfo
{
    USER_NICKNAME=`getJson get_user_info .nick`
    USER_NUMBER=`getJson get_user_info .qq`
    USER_STATE=`getJson get_user_info .state`
    #result=`getJson get_user_info `
    #if [ $? != 0 ]
    #then
    #    showState "Get user information failed."
    #     return 233
    # else
    #    USER_NICKNAME=`echo ${result} | jq -c '.nick' | tr -d "\""`
    #     USER_NUMBER=`echo ${result} | jq -c '.qq' | tr -d "\""`
    #     USER_STATE=`echo ${result} | jq -c '.state' | tr -d "\""`
    #fi
}

function updateFriendsInfo
{
    temp=`execComand get_friend_info | sed 's/\(.*\]\)/\1/g'`
    FRIENDS_COUNT=`echo ${temp} |  awk -F '}' '{print NF-1}'`
    for((i = 0; i < ${FRIENDS_COUNT}; i++))
    do
        FRIENDS_LIST_RAW[$i]=`echo ${temp} | jq ".[$i]"`
    done
    
    for((i = 0; i < ${FRIENDS_COUNT}; i++))
    do
        FRIENDS_NICK_LIST[$i]=`echo ${FRIENDS_LIST_RAW[$i]} | jq ".nick"`
        FRIENDS_MARK_LIST[$i]=`echo ${FRIENDS_LIST_RAW[$i]} | jq ".markname"`
    done
    
    for((i = 0; i < ${FRIENDS_COUNT}; i++))
    do
        FRIENDS_NICK_LIST[$i]=`echo ${FRIENDS_LIST_RAW[$i]} | jq ".nick"`
        FRIENDS_MARK_LIST[$i]=`echo ${FRIENDS_LIST_RAW[$i]} | jq ".markname"`
        FRIENDS_GROUP_LIST[$i]=`echo ${FRIENDS_LIST_RAW[$i]} | jq ".category"`
    done
    
    GROUPS_LIST=($(awk -vRS=' ' '!a[$1]++' <<< ${FRIENDS_GROUP_LIST[@]}))
    GROUPS_COUNT=${#GROUPS_LIST[@]}
    #echo
}

function listGroupFriends
{
    for((i = 0; i < ${GROUPS_COUNT}; i++))
    do
        #echo "$1" 
        #echo "${GROUPS_LIST[$i]}"
        if [ "$1" == "${GROUPS_LIST[$i]}" ]
        then
            echo "Group:${GROUPS_LIST[$i]}"
            for((j = 0; j < ${FRIENDS_COUNT}; j++))
            do
                if [ "$1" == "${FRIENDS_GROUP_LIST[$j]}" ]
                then
                    printf "\tNickname:${FRIENDS_NICK_LIST[$j]}\n"
                fi
            done
        fi      
    done
}

function listAllGroupItem
{
    for((k = 0; k < ${GROUPS_COUNT}; k++))
    do
        listGroupFriends ${GROUPS_LIST[$k]}
    done
} 


updateUserInfo
updateFriendsInfo
listAllGroupItem
#echo ${GROUPS_COUNT}
#echo ${FRIENDS_COUNT}
#echo ${USER_NICKNAME}
#echo ${USER_NUMBER}
#echo ${USER_STATE}
#execComand get_friend_info

#echo $temp
exit
for raw in ${FRIENDS_GROUP_LIST[@]}
do
    echo  "${raw}"
done


