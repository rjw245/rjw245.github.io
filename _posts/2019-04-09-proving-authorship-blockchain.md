---
layout:     post
title:      Proving Authorship with Blockchain
date:       2019-04-09
summary:    Using blockchain technology to prove authorship of a document (like a blog post!)
thumbnail:  fab fa-bitcoin
tags:
- blockchain
- bitcoin
- security
---

Intellectual property rights of digital content creators are difficult to protect because of the ease with which someone can copy others' content and claim it as their own. For example, someone else on the Internet could copy a blog post from this website, post it on their own site with an earlier creation date, and claim authorship of the post. As the author of this site, I'd like to get credit for my posts and prevent others from stealing them. I need some way to *prove* that I am the original author to the public and discredit thieves.

To do this, first I need to prove that the document in question was published by me. This part is easy: I can simply sign the document with my private PGP key. The signature can be verified by the public using the associated public key that I have released. This is a basic application of assymetric cryptography.

The problem is that a content thief is just as capable of signing the same document with *their* private key. If the public is shown two signed documents, they can verify that each came from the person who signed it, but they can't know who is the *original* author. If I can prove that my signature was created *before* a thief's, then I have proved that I am the original author.

Blockchain technology can help solve this problem. The Bitcoin blockchain only grows in time (ignoring pruning which admittedly I don't understand well). This means that the order of blocks in the blockchain corresponds to their order of creation. Blocks that appear earlier in the blockchain must have been created earlier in time. The blockchain also has strong integrity guarantees. Because nodes on the network all agree on what the blockchain should look like, it's impossible for a rogue node (say, one controlled by a would-be thief) to make arbitrary changes -- they will be discarded by well-behaved nodes that dominate the network.

Both of these properties come in handy here. If I publish my signed document to the blockchain before publishing the raw text, then I will have proven that my signature came before any potential thief. A thief may sign my post as their own and post it to the blockchain, but their signature will *necessarily* show up after mine in time. In this system, whoever can point to the "earliest" signature (as timestamped by the blockchain) must be the original author.

Now I'll go through how I've done this myself to prove authorship of this very blog post.

It turns out there is already a website that allows folks to publish arbitrary data to the Bitcoin blockchain: [cryptograffiti.info](https://cryptograffiti.info/){:target="_blank"}. You can attach a file and publish it for a small fee. Incidentally, they use the Bitcoin Cash SV currency rather than regular Bitcoin.

![Screenshot of CryptoGraffiti page](/assets/img/authorship/cryptograffiti.png)

On my local machine, I've gone ahead and signed a copy of the raw Markdown of this post with my private key. I'll attach that to my CryptoGraffiti payload and submit it. That's it!

Here is a link to the signed document on Crypto Graffiti, timestamped by the Bitcoin Cash SV blockchain: [Proof of authorship](https://cryptograffiti.info/#48e786b61aa07673a90ad84e86c58b0a5ef3c52a1d9b304927a22f201fddadf0){:target="_blank"}

And here is a link to my public PGP key: [Riley Wood's PGP public key](http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x04EB0DDD366E09DC){:target="_blank"}

You can try verifying my signature with my public key like so:

```bash
# Get public key
gpg --keyserver keyserver.ubuntu.com --recv 366E09DC
# Verify signed document
gpg --verify $PATH_TO_CRYPTOGRAFFITI_ATTACHMENT
```

Once you do that, you know I must have put that signature on the blockchain. And unless anyone else can point to an earlier signature, you know that I must be the original author. Cool!

I don't think this is necessarily worth doing for all of my posts in the future. I don't really expect anyone to try to steal my content. But for more sensitive content, I think this is a decent way to protect your intellectual property.

