import { ConnectButton } from "@rainbow-me/rainbowkit";
import type { NextPage } from "next";
import Head from "next/head";
import { useState } from 'react';
import { useReadContract, useWriteContract, useAccount } from "wagmi";
import GuestbookArtifact from '../contracts/Guestbook.json';
import { Abi } from "viem";

const guestbookAddress = process.env.NEXT_PUBLIC_GUESTBOOK_ADDRESS as `0x${string}`
const guestbookAbi = GuestbookArtifact.abi as Abi;

type GuestMessage = {
    id: bigint;
    author: `0x${string}`;
    timestamp: bigint;
    content: string;
};

function MessageList({ messages }: { messages: GuestMessage[] }) {
    return (
        <section className="message-list">
            <h2> Messages </h2>
            {
                messages.slice().reverse().map((message) => (
                    <article className="message-card" key={message.id.toString()}>
                        <strong>#{message.id.toString()}</strong>
                        <p>{message.content}</p>
                        <small>{message.author}</small>
                    </article>

                ))
            }
        </section>
    );
}

const Home: NextPage = () => {
    const [content, setContent] = useState('');
    const messagesHook = useReadContract({
        address: guestbookAddress,
        abi: guestbookAbi,
        functionName: 'getAllMessages',
    });
    const { writeContract, isPending } = useWriteContract();

    const chainMessages = (messagesHook.data ?? []) as GuestMessage[];


    const { address, isConnected } = useAccount();


    return (
        <div className="page-shell">
            <Head>
                <title> Guestbook app </title>
            </Head>

            <main className="guestbook">
                <div className="topbar">
                    <ConnectButton />
                </div>
                {
                    isConnected ? (
                        <p className="wallet-status"> Connected as {address} </p>
                    ) : (
                        <p className="wallet-status"> Connect your sepolia wallet </p>
                    )}


                <h1> Guestbook </h1>
                <p className="subtitle"> Write a message to the masses </p>

                <form
                    className="composer"
                    onSubmit={(event) => {
                        event.preventDefault();
                        writeContract(
                            {
                                address: guestbookAddress,
                                abi: guestbookAbi,
                                functionName: 'writeToBook',
                                args: [content],
                            },
                            {
                                onSuccess: () => {
                                    setContent('');
                                    messagesHook.refetch();
                                },
                            }
                        );
                    }}>

                    <textarea
                        value={content}
                        onChange={(event) => setContent(event.target.value)}
                        placeholder="Write your message"
                    />

                    <button type="submit" disabled={!content.trim() || isPending} >
                        {isPending ? 'Confirm in wallet...' : 'Post Message'}
                    </button>

                </form>

                <MessageList messages={chainMessages} />
            </main>
        </div>
    );
};

export default Home;
