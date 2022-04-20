rs.initiate(
    {
        _id: "confRs",
        configsvr: true,
        members: [
            { _id : 0, host : "localhost:27018" }
        ]
    }
);