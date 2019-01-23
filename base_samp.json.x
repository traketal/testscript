{
    "enabled": true,
    "coin": "coinname.json",

    "address": "wallet",

    "rewardRecipients": {
        "pool_reward_fee_address1": 1.5,
        "pool_reward_fee_address2": 0.1
    },

    "paymentProcessing": {
        "enabled": true,
        "paymentInterval": 600,
        "minimumPayment": 0.01,
        "daemon": {
            "host": "127.0.0.1",
            "port": daemonport,
            "user": "rpcuser",
            "password": "rpcpass"
        }
    },

    "ports": {
        "randportlow": {
            "diff": 8
        },
        "randportvar": {
            "diff": 32,
            "varDiff": {
                "minDiff": 8,
                "maxDiff": 1500,
                "targetTime": 15,
                "retargetTime": 90,
                "variancePercent": 30
            }
        },
        "randporthigh": {
            "diff": 2000
        }
    },

    "daemons": [
        {
            "host": "127.0.0.1",
            "port": daemonport,
            "user": "rpcuser",
            "password": "rpcpass"
        }
    ],

    "p2p": {
        "enabled": false,
        "host": "127.0.0.1",
        "port": 19333,
        "disableTransactions": true
    },

    "mposMode": {
        "enabled": false,
        "host": "127.0.0.1",
        "port": 3306,
        "user": "me",
        "password": "mypass",
        "database": "ltc",
        "checkPassword": true,
        "autoCreateWorker": false
    },

    "mongoMode": {
        "enabled": false,
        "host": "127.0.0.1",
        "user": "",
        "pass": "",
        "database": "ltc",
        "authMechanism": "DEFAULT"
    }

}
