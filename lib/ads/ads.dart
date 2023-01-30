import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsProvider{

  static InterstitialAd? interstitialAd;
  int _numInterstitialLoadAttempts = 0;


  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        // adUnitId: 'ca-app-pub-3028010056599796/4042469599',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (_numInterstitialLoadAttempts < 10) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
    // createInterstitialAd();
  }

  static RewardedAd? rewardedAd;
  int _numRewardedLoadAttempts = 0;

  void createRewardedAd() async{
    await RewardedAd.load(
        adUnitId: "ca-app-pub-3940256099942544/5224354917",
        // adUnitId: "ca-app-pub-3028010056599796/6334523222",
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            // print('$ad loaded.');
            rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // print('RewardedAd failed to load: $error');
            rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < 10) {
              createRewardedAd();
            }
          },
        ));
  }

  Future showRewardedAd() async{
    if (rewardedAd == null) {
      return;
    }
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      // onAdShowedFullScreenContent: (RewardedAd ad) =>
      //     print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        // print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        // print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
      },
    );

    rewardedAd!.setImmersiveMode(true);
    await rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async{
          // print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    rewardedAd = null;
    createRewardedAd();
  }

}