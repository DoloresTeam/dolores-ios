/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, {
    Component
} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    TouchableHighlight
} from 'react-native';
import {
    NativeEventEmitter,
    NativeModules
} from 'react-native';

var DLBridgeManager = NativeModules.DLBridgeManager;
const bridgeManager = new NativeEventEmitter(DLBridgeManager)
// const Realm = require('realm');
var subscription;

const UserSchema = {
    name: 'user',
    primaryKey: 'userId',
    properties: {
        userId: {
            type: 'int',
            indexed: true
        },
        userName: 'string',
        nickName: 'string',
    }
};

let realm = new Realm({
    schema: [UserSchema]
});

class CustomButton extends Component {
    render() {
        return (
            <TouchableHighlight
                style={styles.button}
                underlayColor="#a5a5a5"
                onPress={this.props.onPress}>
                <Text style={styles.buttonText}>{this.props.text}</Text>
            </TouchableHighlight>
        );
    }
}

export default class Dolores extends Component {

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            message: '',
            userInfo: '',
        };

    }

    componentDidMount() {
        subscription = bridgeManager.addListener(
            'OCEventReminder',
            (reminder) => {
                this.setState({
                    message: reminder.userId + '-' + reminder.event
                })
            }
        );

        realm.write(() => {
            let user = realm.create('user', {
                userId: 1,
                userName: 'heath',
                nickName: 'nice',
            }, true);
        });
    }

    componentWillUnmount() {
        subscription.remove();
    }


    render() {
        return (<View style={{marginTop: 20}}>

                <Text>{this.state.message}</Text>
                <CustomButton text='RN调用iOS原生方法'
                           onPress={() => {DLBridgeManager.addTest('ok');}}
                />
                <Text style={styles.welcome}>{this.state.userInfo}</Text>
                < CustomButton onPress={() => {
                this.setState({
                    userInfo: realm.objects('user').length
                });
                }
                }
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    button: {
        margin: 5,
        backgroundColor: 'white',
        padding: 10,
        borderWidth: 1,
        borderColor: '#facece',
    },
});

AppRegistry.registerComponent('Dolores', () => Dolores);